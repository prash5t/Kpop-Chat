import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/core/constants/text_constants.dart';

class AppNameOnTopOfScreen extends StatelessWidget {
  const AppNameOnTopOfScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 70.61.h),
        child: const CustomText(
          text: "${TextConstants.appName}\n${TextConstants.appNameKorean}",
          textColor: Colors.white,
          size: 20,
          isBold: true,
          alignCenter: true,
        ));
  }
}
