import 'package:flutter/material.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/main.dart';

class CommonDecoration {
  static LinearGradient appPrimaryGradientBackground() {
    return const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [ColorConstants.primaryColor, ColorConstants.primaryColorPink]);
  }

  static BoxDecoration floatingActionBoxDec() {
    return BoxDecoration(
        color: Theme.of(navigatorKey.currentContext!).colorScheme.onSecondary,
        borderRadius: BorderRadius.circular(4));
  }
}
