import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/constants/google_ads_id.dart';
import 'package:kpopchat/core/utils/admob_services.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_image_widget.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/widgets/friend_profile_widgets/friend_profile_appbar.dart';
import 'package:simple_tags/simple_tags.dart';

class VirtualFriendProfileScreen extends StatefulWidget {
  final VirtualFriendModel friendInfo;
  const VirtualFriendProfileScreen({super.key, required this.friendInfo});

  @override
  State<VirtualFriendProfileScreen> createState() =>
      _VirtualFriendProfileScreenState();
}

class _VirtualFriendProfileScreenState
    extends State<VirtualFriendProfileScreen> {
  ValueNotifier<BannerAd?> friendProfileScreenBannerAd =
      ValueNotifier<BannerAd?>(null);
  ValueNotifier<InterstitialAd?> friendProfileInterstitialAd =
      ValueNotifier<InterstitialAd?>(null);
  bool interstitialAdShown = false;

  @override
  void initState() {
    _loadInterstitialAd();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadBannerAd();
  }

  void _showInterstitialAd() async {
    await AdMobServices.showInterstitialAd(friendProfileInterstitialAd, () {
      _loadInterstitialAd();
    });
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: GoogleAdId.friendProfileScreenInterstitialAdId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              friendProfileInterstitialAd.value = ad;
              if (!interstitialAdShown) {
                _showInterstitialAd();
              }
              interstitialAdShown = true;
            },
            onAdFailedToLoad: (LoadAdError error) =>
                friendProfileInterstitialAd.value = null));
  }

  void _loadBannerAd() async {
    friendProfileScreenBannerAd.value = await AdMobServices
        .getBannerAdByGivingAdId(GoogleAdId.friendProfileScreenBannerAdId)
      ..load();
  }

  @override
  void dispose() {
    friendProfileScreenBannerAd.value?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> hobbies =
        widget.friendInfo.hobbies!.map((e) => e.toString()).toList();
    return Scaffold(
      appBar: buildFriendProfileAppBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: friendProfileScreenBannerAd,
        builder: (context, value, child) {
          return CommonWidgets.buildBannerAd(value);
        },
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30.h),
                Container(
                  width: double.infinity,
                  height: 300.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.r),
                    boxShadow: const [BoxShadow(blurRadius: 15.0)],
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.r),
                      child: CachedImageWidget(
                          imageUrl: widget.friendInfo.displayPictureUrl ?? "")),
                ),
                SizedBox(height: 20.h),
                Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 7.h),
                          child: CircleAvatar(
                            backgroundColor: ColorConstants.successColor,
                            radius: 9.r,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: CustomText(
                            text:
                                "${widget.friendInfo.name}, ${widget.friendInfo.age}",
                            textColor: Theme.of(context).primaryColor,
                            isBold: true,
                            size: 30.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                  ],
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Icon(Icons.home, size: 20.sp),
                    SizedBox(width: 7.w),
                    CustomText(
                      text:
                          "Lives in ${widget.friendInfo.city}, ${widget.friendInfo.country}",
                      size: 16.sp,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                CustomText(
                  text: "Hobbies",
                  size: 18.sp,
                  isBold: true,
                  textColor: Theme.of(context).primaryColor,
                ),
                SizedBox(height: 10.h),
                SimpleTags(
                  content: hobbies,
                  wrapSpacing: 8,
                  wrapRunSpacing: 8,
                  tagTextStyle: TextStyle(
                    fontSize: 12.sp,
                  ),
                  tagContainerPadding: const EdgeInsets.all(8),
                  tagContainerDecoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
