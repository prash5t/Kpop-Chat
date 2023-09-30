import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';

Row buildAppBarForMenuScreen(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(CupertinoIcons.back)),
      CustomText(
        text: "My Profile",
        size: 20.sp,
        isBold: true,
        textColor: Theme.of(context).primaryColor,
      ),
      SizedBox(width: 20.w)
    ],
  );
}
