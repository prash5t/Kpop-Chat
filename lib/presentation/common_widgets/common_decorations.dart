import 'package:flutter/material.dart';
import 'package:kpopchat/core/constants/color_constants.dart';

class CommonDecoration {
  static LinearGradient appPrimaryGradientBackground() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ColorConstants.primaryColor, ColorConstants.primaryColorPink]);
  }
}
