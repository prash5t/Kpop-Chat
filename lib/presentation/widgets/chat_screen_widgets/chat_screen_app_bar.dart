import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_circle_avatar.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/widgets/chat_screen_widgets/online_status_widget.dart';

PreferredSize chatScreenAppBar(
    BuildContext context, VirtualFriendModel virtualFriend) {
  final String imageUrl = virtualFriend.displayPictureUrl!;

  return CommonWidgets.customAppBar(
      context,
      Row(
        children: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(CupertinoIcons.back)),
          SizedBox(width: 17.w),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(AppRoutes.friendProfileScreen,
                  arguments: virtualFriend);
            },
            child: Row(children: [
              CachedCircleAvatar(imageUrl: imageUrl),
              SizedBox(width: 20.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: "${virtualFriend.name}",
                    isBold: true,
                    size: 20.sp,
                    textColor: Theme.of(context).primaryColor,
                  ),
                  SizedBox(height: 1.h),
                  const OnlineStatusWidget()
                ],
              )
            ]),
          ),
        ],
      ));
}
