import 'package:flutter/material.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/common_widgets/loading_overlay_screen.dart';

class LoadingUtils {
  static showLoadingDialog() {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      pageBuilder: (_, __, ___) {
        return LoadingOverlayScreen();
      },
    );
  }

  static hideLoadingDialog() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(navigatorKey.currentContext!).pop();
    });
  }
}
