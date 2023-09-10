import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'custom_text.dart';

class CommonWidgets {
  static PreferredSize customAppBar(
      BuildContext context, Widget appBarContents) {
    return PreferredSize(
      preferredSize: Size.fromHeight(70.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: appBarContents,
          ),
          SizedBox(height: 13.h),
          Divider(
            height: 2.h,
            thickness: 0.5.sp,
          )
        ],
      ),
    );
  }

  static customFlushBar(BuildContext context, String message) {
    Flushbar(
      backgroundColor: Theme.of(context).primaryColor,
      flushbarPosition: FlushbarPosition.TOP,
      messageText: CustomText(
        text: message,
        alignCenter: true,
        textColor: Theme.of(context).colorScheme.background,
      ),
      duration: const Duration(seconds: 1),
    ).show(context);
  }

  static Widget buildLineInBottomSheet() =>
      Center(child: Container(color: Colors.grey, width: 88.w, height: 4.h));

  /// fyi: being used in bool bottomsheet, error bottomsheet
  static RoundedRectangleBorder buildCircularBorderOnTop30r() {
    return RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30.r),
      topRight: Radius.circular(30.r),
    ));
  }
}
