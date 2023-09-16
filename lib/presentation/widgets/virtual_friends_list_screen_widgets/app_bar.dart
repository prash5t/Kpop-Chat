import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/constants/analytics_constants.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/analytics.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

PreferredSize conversationsScreenAppBar(BuildContext context) {
  return CommonWidgets.customAppBar(
    context,
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildMenuButton(context),
        CustomText(
            text: TextConstants.appName,
            textColor: Theme.of(context).primaryColor,
            size: 20.sp,
            isBold: true),
        const SizedBox()
        // IconButton(
        //     onPressed: () {
        //       // BlocProvider.of<VirtualFriendsListCubit>(context)
        //       //     .createVirtualFriend();
        //     },
        //     icon: const Icon(Icons.create))
      ],
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
