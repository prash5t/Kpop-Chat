import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/presentation/common_widgets/cached_circle_avatar.dart';

class CustomMsgAvatarWidget extends StatelessWidget {
  const CustomMsgAvatarWidget({
    super.key,
    required this.context,
    required this.virtualFriend,
  });

  final BuildContext context;
  final VirtualFriendModel virtualFriend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10.w, right: 8.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.friendProfileScreen,
              arguments: virtualFriend);
        },
        child: CachedCircleAvatar(
            radius: 15.r, imageUrl: virtualFriend.displayPictureUrl ?? ""),
      ),
    );
  }
}
