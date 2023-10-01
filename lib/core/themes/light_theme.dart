import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/core/constants/color_constants.dart';
import 'package:kpopchat/core/constants/text_constants.dart';

final lightTheme = ThemeData(
    brightness: Brightness.light,
    // useMaterial3: true,
    fontFamily: TextConstants.kBarlowFont,
    primaryColor: ColorConstants.primaryColor,
    colorScheme: const ColorScheme.light(
      primary: ColorConstants.primaryColor,
      primaryContainer: Color(0xFF212121),
      onPrimary: ColorConstants.primaryColor,
      secondary: Colors.white,
      onSecondary: Colors.white,
      tertiary: ColorConstants.unCheckedColorLightTheme,
      onTertiary: ColorConstants.bgColorOfBotMsgLightTheme,
      // error: Colors.red,
      // onError: Colors.red,
      background: Colors.white,
      // onBackground: Colors.white,
      // surface: Colors.white,
      // onSurface: AppColors.primaryColor,
    ),
    iconTheme: const IconThemeData(
      color: ColorConstants.primaryColor,
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.all(ColorConstants.primaryColor),
      checkColor: MaterialStateProperty.all(Colors.white),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.withOpacity(0.5),
    ),
    // dialogBackgroundColor: Colors.white,

    // dialogTheme: DialogTheme(
    //   backgroundColor: Colors.white,
    //   contentTextStyle: TextStyle(
    //     color: AppColors.lightTextColor,
    //     fontSize: 16.sp,
    //     fontWeight: FontWeight.normal,
    //   ),
    //   titleTextStyle: TextStyle(
    //     color: AppColors.lightTextColor,
    //     fontSize: 18.sp,
    //     fontWeight: FontWeight.normal,
    //   ),
    // ),

    // radioTheme: RadioThemeData(
    //     fillColor: MaterialStateProperty.all(AppColors.primaryColor)),
    // cardColor: Colors.white,
    // switchTheme: SwitchThemeData(
    //     thumbColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
    //     trackColor:
    //         MaterialStateProperty.all(const Color.fromRGBO(35, 116, 225, 0.2))),
    // scaffoldBackgroundColor: Colors.white,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: ColorConstants.primaryColor,
      foregroundColor: Colors.white,
      textStyle: TextStyle(color: Colors.white, fontSize: 18.sp),
    )),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.grey,
      systemOverlayStyle: SystemUiOverlayStyle(
        // statusBarBrightness: Brightness.light,
        statusBarColor: Colors.grey,
        statusBarIconBrightness: Brightness.dark,
      ),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 15.sp,
      ),
      actionsIconTheme:
          const IconThemeData(color: ColorConstants.lightTextColor),
    ),
    // bottomAppBarTheme: BottomAppBarTheme(
    //     // color: AppColors.lightScaffoldColor,
    //     ),
    // bottomAppBarColor: AppColors.lightScaffoldColor,
    hintColor: Colors.grey,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: ColorConstants.primaryColor,
    ),
    listTileTheme:
        const ListTileThemeData(iconColor: ColorConstants.primaryColor));
