import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kpopchat/core/constants/asset_path_constants.dart';

class SpiralLinesWidget extends StatelessWidget {
  const SpiralLinesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: -40.w,
        top: -310.h,
        child: SvgPicture.asset(AssetPathConstants.kSpiralLines));
  }
}
