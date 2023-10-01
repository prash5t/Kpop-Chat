import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/core/utils/date_to_string.dart';
import 'package:kpopchat/core/utils/get_view_count_string.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:kpopchat/data/models/virtual_friend_post_model.dart';
import 'package:kpopchat/data/repository/data_filter_repo.dart';
import 'package:kpopchat/presentation/common_widgets/bool_bottom_sheet.dart';
import 'package:kpopchat/presentation/common_widgets/cached_circle_avatar.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

class VirtualFriendPostWidget extends StatelessWidget {
  final VirtualFriendPostModel postData;
  const VirtualFriendPostWidget({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () async {
        bool shouldReportPost = await booleanBottomSheet(
              context: context,
              titleText: TextConstants.reportPostTitle,
              boolTrueText: "Report",
            ) ??
            false;
        if (shouldReportPost) {
          locator<DataFilterRepo>().reportPost(postData);
          CommonWidgets.customFlushBar(context, "Reported!");
        }
      },
      child: Column(
        children: [_buildPosterInfoWidget(context), _buildPostWidget()],
      ),
    );
  }

  Padding _buildPostWidget() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(text: "${postData.caption}"),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "${dateToString(postData.datePublished.toString())}",
                size: 14,
                textColor: Colors.grey,
              ),
              CustomText(
                text: "Views: ${getViewCount(postData.viewsCount ?? 0)}",
                size: 14,
                textColor: Colors.grey,
              )
            ],
          ),
          const Divider()
        ],
      ),
    );
  }

  ListTile _buildPosterInfoWidget(BuildContext context) {
    return ListTile(
      leading: GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(
              AppRoutes.friendProfileScreen,
              arguments: postData.poster),
          child: CachedCircleAvatar(
              imageUrl: postData.poster!.displayPictureUrl!)),
      title: GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            AppRoutes.friendProfileScreen,
            arguments: postData.poster),
        child: CustomText(
          text: postData.poster?.name ?? "",
          textColor: Theme.of(context).primaryColor,
          isBold: true,
        ),
      ),
      subtitle: Text(postData.poster?.profession ?? ""),
      trailing: IconButton(
          onPressed: () async {
            bool shouldReportPost = await booleanBottomSheet(
                  context: context,
                  titleText: TextConstants.reportPostTitle,
                  boolTrueText: "Report",
                ) ??
                false;
            if (shouldReportPost) {
              locator<DataFilterRepo>().reportPost(postData);
              CommonWidgets.customFlushBar(context, "Reported!");
            }
          },
          icon: Icon(
            CupertinoIcons.ellipsis,
            size: 18,
            color: Theme.of(context).colorScheme.primaryContainer,
          )),
    );
  }
}
