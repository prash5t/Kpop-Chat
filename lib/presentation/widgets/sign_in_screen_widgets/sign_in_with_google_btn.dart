import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/core/constants/asset_path_constants.dart';
import 'package:kpopchat/core/constants/color_constants.dart';

class SignInWithGoogleBtn extends StatelessWidget {
  final Function() onTap;
  const SignInWithGoogleBtn({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        height: 56.h,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          border: Border.all(color: ColorConstants.oxFFE8ECF4),
          borderRadius: BorderRadius.all(Radius.circular(500.sp)),
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(AssetPathConstants.kGoogleLogo,
                  height: 22.h, width: 22.w),
              SizedBox(width: 16.w),
              const CustomText(
                  text: "Sign In with Google",
                  fontWeight: FontWeight.w600,
                  size: 14,
                  textColor: ColorConstants.oxFF6A707C)
            ],
          ),
        ),
      ),
    );
  }
}
