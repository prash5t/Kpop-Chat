import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/constants/color_constants.dart';

class OnlineStatusWidget extends StatelessWidget {
  const OnlineStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color onlineStatusColor = ColorConstants.successColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: onlineStatusColor,
          radius: 5.r,
        ),
        SizedBox(width: 4.r),
        Text(
          "Online",
          style: TextStyle(
            fontSize: 17.sp,
            color: onlineStatusColor,
          ),
        )
      ],
    );
  }
}

class RecentlyActiveWidget extends StatelessWidget {
  const RecentlyActiveWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Color onlineStatusColor = ColorConstants.primaryColor;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: onlineStatusColor,
          radius: 5.r,
        ),
        SizedBox(width: 4.r),
        Text(
          "Recently Joined",
          style: TextStyle(
            fontSize: 17.sp,
            color: onlineStatusColor,
          ),
        )
      ],
    );
  }
}
