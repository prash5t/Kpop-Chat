import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/business_logic/auth_checker_cubit/auth_checker_cubit.dart';
import 'package:kpopchat/business_logic/theme_cubit.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/constants/asset_path_constants.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/constants/google_ads_id.dart';
import 'package:kpopchat/core/constants/network_constants.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/themes/dark_theme.dart';
import 'package:kpopchat/core/utils/admob_services.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/core/utils/consent_helper.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/user_model.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/common_widgets/bool_bottom_sheet.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/widgets/menu_screen_widgets/menu_app_bar.dart';
import 'package:kpopchat/presentation/widgets/menu_screen_widgets/menu_list_tile.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // ValueNotifier<BannerAd?> menuScreenBannerAd = ValueNotifier<BannerAd?>(null);
  ValueNotifier<InterstitialAd?> switchThemeInterstitialAd =
      ValueNotifier<InterstitialAd?>(null);
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // _loadBannerAd();
    _loadInterstitialAd();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: GoogleAdId.switchThemeInterstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) => switchThemeInterstitialAd.value = ad,
            onAdFailedToLoad: (LoadAdError error) =>
                switchThemeInterstitialAd.value = null));
  }

  // void _loadBannerAd() async {
  //   menuScreenBannerAd.value = await AdMobServices.getBannerAdByGivingAdId(
  //       GoogleAdId.menuScreenBannerAdId)
  //     ..load();
  // }

  @override
  void dispose() {
    // menuScreenBannerAd.value?.dispose();
    switchThemeInterstitialAd.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? loggedInUserData = SharedPrefsHelper.getUserProfile();
    return Scaffold(
      appBar: CommonWidgets.customAppBar(
          context, buildAppBarForMenuScreen(context)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: ValueListenableBuilder(
      //   valueListenable: menuScreenBannerAd,
      //   builder: (context, value, child) {
      //     return CommonWidgets.buildBannerAd(value);
      //   },
      // ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            _buildUserDPNameEmailWidget(loggedInUserData, context),
            const Divider(),
            _buildScoreWidget(loggedInUserData, context),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: CustomText(
                text: "Dark Mode",
                isBold: true,
                textColor: Theme.of(context).primaryColor,
              ),
              trailing: BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, currentTheme) {
                  return Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: CupertinoSwitch(
                          activeColor: ColorConstants.primaryColor,
                          value: currentTheme == darkTheme,
                          onChanged: (bool val) async {
                            await AdMobServices.showInterstitialAd(
                                switchThemeInterstitialAd,
                                () => _loadInterstitialAd());
                            BlocProvider.of<ThemeCubit>(
                                    navigatorKey.currentContext!)
                                .changeTheme();
                          }));
                },
              ),
            ),
            const Divider(),
            CustomListTile(
              title: "Privacy Policy",
              leadingIcon: CupertinoIcons.book,
              titleColor: Theme.of(context).primaryColor,
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse(NetworkConstants.privacyPolicyUrl),
                    mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch privacy policy url';
                }
              },
            ),
            const Divider(),
            CustomListTile(
              title: "Ads & In-App Unlocks",
              leadingIcon: CupertinoIcons.money_dollar_circle,
              titleColor: Theme.of(context).primaryColor,
              onTap: () async {
                if (!await launchUrl(
                    Uri.parse(NetworkConstants.inAppEconomyUrl),
                    mode: LaunchMode.externalApplication)) {
                  throw 'Could not launch in-app-economy url';
                }
              },
            ),
            const Divider(),
            CustomListTile(
              title: "Privacy Choices",
              leadingIcon: CupertinoIcons.shield,
              titleColor: Theme.of(context).primaryColor,
              onTap: () async {
                await showPrivacyChoices();
              },
            ),
            const Divider(),
            CustomListTile(
              title: "Sign out",
              leadingIcon: Icons.logout,
              titleColor: Theme.of(context).primaryColor,
              onTap: () async {
                await logoutUser(context);
              },
            ),
            const Divider(),
            CustomListTile(
              title: "Delete Account",
              leadingIcon: Icons.delete_forever,
              titleColor: Colors.red,
              onTap: () async {
                await _confirmAndDeleteAccount(context);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Row _buildUserDPNameEmailWidget(
      UserModel? loggedInUserData, BuildContext context) {
    return Row(
      children: [
        AvatarGlow(
          glowColor: ColorConstants.primaryColor,
          glowRadiusFactor: 0.6,
          child: Material(
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.grey[300]!)),
              width: 80,
              height: 80,
              child: CachedNetworkImage(imageUrl: loggedInUserData!.photoURL!),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "${loggedInUserData.displayName}",
              isBold: true,
              size: 18,
              textColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 10),
            CustomText(
              text: "${loggedInUserData.email}",
              textColor: Colors.grey,
            ),
          ],
        )
      ],
    );
  }

  Row _buildScoreWidget(UserModel? loggedInUserData, BuildContext context) {
    return Row(
      children: [
        AvatarGlow(
          glowColor: ColorConstants.primaryColor,
          glowRadiusFactor: 0.6,
          child: Material(
            elevation: 3,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.grey[300]!)),
              width: 80,
              height: 80,
              child: Image.asset(AssetPathConstants.kMedalPNG),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: "My Kpop Score",
              isBold: true,
              size: 18,
              textColor: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 10),
            CustomText(
              text: "${loggedInUserData?.kpopScore ?? 0}",
              textColor: Colors.grey,
            ),
          ],
        )
      ],
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    bool shouldLogout = await booleanBottomSheet(
            context: context,
            titleText: TextConstants.logoutTitle,
            boolTrueText: TextConstants.logoutText) ??
        false;
    if (shouldLogout) {
      logEventInAnalytics(AnalyticsConstants.kEventSignOut);
      BlocProvider.of<AuthCheckerCubit>(navigatorKey.currentContext!)
          .signOutUser();
    }
  }

  Future<void> _confirmAndDeleteAccount(BuildContext context) async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Delete account?'),
          content: const Text(
            'This permanently removes your profile, chat history, and ad-unlock activity. It can’t be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    logEventInAnalytics(AnalyticsConstants.kEventSignOut);
    final outcome =
        await BlocProvider.of<AuthCheckerCubit>(navigatorKey.currentContext!)
            .deleteUserAccount();

    final ctx = navigatorKey.currentContext;
    if (ctx == null) return;
    switch (outcome) {
      case DeletionOutcome.success:
        // Navigation to sign-in already happened inside the cubit.
        break;
      case DeletionOutcome.requiresReauth:
        CommonWidgets.customFlushBar(
          ctx,
          'Sign in again, then try Delete Account once more. Or email awarself@gmail.com to delete your account.',
        );
        break;
      case DeletionOutcome.failed:
        CommonWidgets.customFlushBar(
          ctx,
          'Couldn’t complete deletion. Email awarself@gmail.com to delete your account.',
        );
        break;
    }
  }
}
