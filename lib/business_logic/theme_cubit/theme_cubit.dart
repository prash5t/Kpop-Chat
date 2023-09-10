import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/core/constants/shared_preferences_keys.dart';
import 'package:kpopchat/core/utils/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/themes/dark_theme.dart';
import '../../core/themes/light_theme.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit() : super(lightTheme);

  getTheme() async {
    bool isDark =
        locator<SharedPreferences>().getBool(SharedPrefsKeys.isDarkMode) ??
            false;
    await Future.delayed(Duration.zero);
    if (isDark) {
      emit(darkTheme);
      changeOverlayColor(true);
    } else {
      emit(lightTheme);
      changeOverlayColor(false);
    }
  }

  changeTheme() async {
    bool isDarkCurrently = state == darkTheme;
    locator<SharedPreferences>()
        .setBool(SharedPrefsKeys.isDarkMode, !isDarkCurrently);
    changeOverlayColor(!isDarkCurrently);
    emit(isDarkCurrently ? lightTheme : darkTheme);
  }
}

changeOverlayColor(bool isDark) {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.grey));
}
