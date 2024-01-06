import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/presentation/common_widgets/common_decorations.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/core/constants/asset_path_constants.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/constants/network_constants.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/widgets/sign_in_screen_widgets/sign_in_with_google_btn.dart';
import 'package:kpopchat/data/repository/auth_repo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/sign_in_screen_widgets/app_name_on_top_widget.dart';
import '../widgets/sign_in_screen_widgets/spiral_lines_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // bool isLoading = false;
  TapGestureRecognizer? _policyRecognizer;

  @override
  void initState() {
    _policyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        logEventInAnalytics(AnalyticsConstants.kEventPolicyClicked);
        _launchUrl(NetworkConstants.policyUrl);
      };
    super.initState();
  }

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            gradient: CommonDecoration.appPrimaryGradientBackground()),
        child: buildSignInOverallWidget(),
      ),
    );
  }

  Widget buildSignInOverallWidget() {
    return Center(
      child: Column(children: [
        const AppNameOnTopOfScreen(),
        const Spacer(),
        Stack(clipBehavior: Clip.none, alignment: Alignment.topLeft, children: [
          const SpiralLinesWidget(),
          Positioned(
            top: -310.h,
            left: 80.w,
            child: CircleAvatar(
              radius: 110.r,
              backgroundImage: const AssetImage(AssetPathConstants.kLogoIcon),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.r),
                topRight: Radius.circular(30.r),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 18.h),
                  child: CommonWidgets.buildLineInBottomSheet(),
                ),
                const WelcomeText(),
                const PleaseLoginText(),
                SignInWithGoogleBtn(onTap: () async {
                  logEventInAnalytics(AnalyticsConstants.kEventSignInClick);
                  if (await locator<AuthRepo>().signInWithGoogle()) {
                    // sign in success
                    logEventInAnalytics(AnalyticsConstants.kEventSignedIn);
                    Navigator.of(navigatorKey.currentContext!)
                        .pushNamedAndRemoveUntil(
                            AppRoutes.dashboardScreen, (route) => false);
                  }
                }),
                PolicyWidget(policyRecognizer: _policyRecognizer),
              ],
            ),
          ),
          Positioned(
            top: -140,
            child: Image.asset(
              AssetPathConstants.kWaitingGirlGIF,
              width: 200,
            ),
          ),
          // Positioned(
          //   top: -120,
          //   left: 200,
          //   child: Image.asset(
          //     AssetPathConstants.kWaitingDogGIF,
          //     width: 180,
          //   ),
          // ),
        ])
      ]),
    );
  }
}

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({
    super.key,
    required TapGestureRecognizer? policyRecognizer,
  }) : _policyRecognizer = policyRecognizer;

  final TapGestureRecognizer? _policyRecognizer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(top: 31.h, bottom: Platform.isAndroid ? 24.h : 35.h),
      child: Text.rich(TextSpan(
          style: TextStyle(
              fontSize: 16.sp, height: 1.44, fontWeight: FontWeight.w400),
          text: "By signing in, I agree to the ",
          children: [
            TextSpan(
                text: 'TOS & Privacy Policy',
                recognizer: _policyRecognizer,
                style: const TextStyle(
                    height: 1.44,
                    fontFamily: 'Barlow',
                    fontWeight: FontWeight.bold,
                    color: ColorConstants.primaryColor))
          ])),
    );
  }
}

class PleaseLoginText extends StatelessWidget {
  const PleaseLoginText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 7.h, bottom: 31.h),
      child: const CustomText(
        text: "Welcome to the ultimate K-pop fan haven!",
        size: 16,
        textColor: ColorConstants.oxFF545454,
      ),
    );
  }
}

class WelcomeText extends StatelessWidget {
  const WelcomeText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 35.h),
      child: const CustomText(
        text: "Yayyy!!",
        isBold: true,
        size: 35,
        textColor: ColorConstants.oxFF545454,
      ),
    );
  }
}
