import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

PreferredSize conversationsScreenAppBar(BuildContext context,
    {bool isForPostsScreen = false}) {
  return CommonWidgets.customAppBar(
    context,
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
              text: isForPostsScreen
                  ? "@Kpop Posts"
                  : "@" + TextConstants.appName,
              textColor: Theme.of(context).primaryColor,
              size: 20.sp,
              isBold: true),
          buildMenuButton(context),

          // IconButton(
          //     onPressed: () {
          //       // BlocProvider.of<VirtualFriendsListCubit>(context)
          //       //     .createVirtualFriend();
          //     },
          //     icon: const Icon(Icons.create))
        ],
      ),
    ),
  );
}

IconButton buildMenuButton(BuildContext context) {
  return IconButton(
      onPressed: () {
        logEventInAnalytics(AnalyticsConstants.kEventMenuScreenClicked);
        Navigator.pushNamed(context, AppRoutes.menuScreen);
      },
      icon: Icon(
        Icons.menu,
        size: 25.sp,
      ));
}
