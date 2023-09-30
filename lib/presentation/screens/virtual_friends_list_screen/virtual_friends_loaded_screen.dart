import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/constants/google_ads_id.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/admob_services.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/core/utils/shared_preferences_helper.dart';
import 'package:kpopchat/data/models/schema_virtual_friend_model.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_image_widget.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/widgets/virtual_friends_list_screen_widgets/app_bar.dart';
import 'package:kpopchat/presentation/widgets/virtual_friends_list_screen_widgets/zero_virtual_friends_widget.dart';

class VirtualFriendsLoadedScreen extends StatefulWidget {
  final List<SchemaVirtualFriendModel> virtualFriends;
  final ScrollController scrollController;
  const VirtualFriendsLoadedScreen(
      {super.key,
      required this.virtualFriends,
      required this.scrollController});

  @override
  State<VirtualFriendsLoadedScreen> createState() =>
      _VirtualFriendsLoadedScreenState();
}

class _VirtualFriendsLoadedScreenState
    extends State<VirtualFriendsLoadedScreen> {
  ValueNotifier<BannerAd?> virtualFriendsListScreenBannerAd =
      ValueNotifier<BannerAd?>(null);
  ValueNotifier<RewardedAd?> unlockFriendRewardedAd =
      ValueNotifier<RewardedAd?>(null);
  int coinsEarned = 0;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBannerAd();
    _loadRewardedAd();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: GoogleAdId.unlockFriendRewardedAdId,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
              // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          unlockFriendRewardedAd.value = ad;
        }, onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('RewardedAd failed to load: $error');
        }));
  }

  void _loadBannerAd() async {
    virtualFriendsListScreenBannerAd.value = await AdMobServices
        .getBannerAdByGivingAdId(GoogleAdId.homeScreenBannerAdId)
      ..load();
  }

  @override
  void dispose() {
    unlockFriendRewardedAd.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<SchemaVirtualFriendModel> virtualFriends = widget.virtualFriends;

    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: conversationsScreenAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: virtualFriendsListScreenBannerAd,
        builder: (context, value, child) {
          return CommonWidgets.buildBannerAd(value);
        },
      ),
      body: virtualFriends.isEmpty
          ? const ZeroVirtualFriendsWidget()
          : ListView.builder(
              controller: widget.scrollController,
              key: const PageStorageKey<String>('chatPage'),
              itemCount: virtualFriends.length,
              itemBuilder: (context, index) {
                VirtualFriendModel friendData = virtualFriends[index].info!;
                bool shouldLockProfile =
                    !SharedPrefsHelper.lastUnlockWasWithinAnHour(
                            friendData.id!) &&
                        index != 0;
                return Stack(
                  children: [
                    ImageFiltered(
                      imageFilter: ImageFilter.blur(sigmaY: 2, sigmaX: 2),
                      enabled: shouldLockProfile,
                      child: buildVirtualFriendCard(context, friendData,
                          virtualFriends, index, deviceHeight),
                    ),
                    // below lock friend card if user need to see rewarded ad
                    if (shouldLockProfile)
                      buildLockWidget(virtualFriends, index, deviceHeight)
                  ],
                );
              }),
    );
  }

  Padding buildLockWidget(List<SchemaVirtualFriendModel> virtualFriends,
      int index, double deviceHeight) {
    return Padding(
      padding: paddingForFriendCard(virtualFriends, index),
      child: InkWell(
        onTap: () {
          try {
            unlockFriendRewardedAd.value?.show(
              onUserEarnedReward: (ad, reward) {
                SharedPrefsHelper.setNewUnlockTime(
                    virtualFriends[index].info!.id!);
                BlocProvider.of<VirtualFriendsListCubit>(context)
                    .getVirtualFriends();
                logEventInAnalytics(
                    AnalyticsConstants.kEventRewardedAdEarnedReward,
                    parameters: {"coin": reward.amount});
                coinsEarned += reward.amount.toInt();
                increasePropertyCount(AnalyticsConstants.kPropertyRewardsEarned,
                    reward.amount.toDouble());
                debugPrint("Total coins: $coinsEarned");
              },
            );
            debugPrint("Tapped locked profile");
          } catch (e) {
            debugPrint("error showing rewarded ad: $e");
            _loadRewardedAd();
          }
        },
        child: Container(
            decoration:
                const BoxDecoration(color: Colors.transparent, boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(
                  5.0,
                  5.0,
                ),
                blurRadius: 10.0,
                spreadRadius: 2.0,
              )
            ]),
            width: double.infinity,
            height: deviceHeight * 0.4,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.lock_clock_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 12),
                        child: CustomText(
                          text: "Ad",
                          isBold: true,
                          size: 14,
                        ),
                      )
                    ],
                  ),
                  CustomText(
                    text: "+ 1 HOUR",
                    isBold: true,
                    textColor: Colors.white,
                    size: 20,
                  )
                ],
              ),
            )),
      ),
    );
  }

  InkWell buildVirtualFriendCard(
      BuildContext context,
      VirtualFriendModel friendData,
      List<SchemaVirtualFriendModel> virtualFriends,
      int index,
      double deviceHeight) {
    return InkWell(
      onTap: () {
        Navigator.of(context)
            .pushNamed(AppRoutes.chatScreen, arguments: friendData);
      },
      child: Center(
        child: Padding(
          padding: paddingForFriendCard(virtualFriends, index),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              SizedBox(
                width: double.infinity,
                height: deviceHeight * 0.4,
                child:
                    CachedImageWidget(imageUrl: friendData.displayPictureUrl!),
              ),
              Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                      decoration: const BoxDecoration(boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                          blurRadius: 10.0,
                          spreadRadius: 2.0,
                        ),
                        BoxShadow(
                          color: Colors.transparent,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 0.0,
                          spreadRadius: 0.0,
                        ),
                      ]),
                      height: 80.h,
                      width: double.infinity),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, bottom: 10.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.green[400],
                                  borderRadius: BorderRadius.circular(10.r)),
                              width: 55.w,
                              height: 22.h,
                              child: CustomText(
                                text: "Active",
                                size: 11.sp,
                                isBold: true,
                                textColor: Colors.white,
                              ),
                            ),
                            CustomText(
                              text: "${friendData.name}, ${friendData.age}",
                              isBold: true,
                              size: 20.h,
                              textColor: Colors.white,
                            ),
                            CustomText(
                              text:
                                  "Lives in ${friendData.city}, ${friendData.country}",
                              size: 13.sp,
                              textColor: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(bottom: 8.h, right: 20.w),
                            child: const Icon(
                              Icons.message,
                              color: Colors.white,
                              size: 30,
                            ))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  EdgeInsets paddingForFriendCard(
      List<SchemaVirtualFriendModel> virtualFriends, int index) {
    return EdgeInsets.only(
        left: 5.w,
        right: 5.w,
        top: 3.h,
        bottom: virtualFriends.length - index == 1 ? 60.h : 3.h);
  }
}
