import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

PreferredSize buildFriendProfileAppBar(BuildContext context) {
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
          CustomText(
            text: "Virtual Friend Profile",
            isBold: true,
            size: 20,
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ));
}
