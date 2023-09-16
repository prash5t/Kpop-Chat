import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kpopchat/business_logic/auth_checker_cubit/auth_checker_cubit.dart';
import 'package:kpopchat/business_logic/theme_cubit.dart';
import 'package:kpopchat/core/constants/text_constants.dart';
import 'package:kpopchat/core/themes/dark_theme.dart';
import 'package:kpopchat/main.dart';
import 'package:kpopchat/presentation/common_widgets/bool_bottom_sheet.dart';
import 'package:kpopchat/presentation/common_widgets/common_widgets.dart';
import 'package:kpopchat/presentation/common_widgets/custom_text.dart';
import 'package:kpopchat/presentation/widgets/menu_screen_widgets/menu_app_bar.dart';
import 'package:day_night_themed_switch/day_night_themed_switch.dart';
import 'package:kpopchat/presentation/widgets/menu_screen_widgets/menu_list_tile.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonWidgets.customAppBar(
          context, buildAppBarForMenuScreen(context)),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens_outlined),
              title: CustomText(
                text: "Theme",
                isBold: true,
                textColor: Theme.of(context).primaryColor,
              ),
              trailing: BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, currentTheme) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    child: DayNightSwitch(
                        value: currentTheme == darkTheme,
                        onChanged: (bool val) {
                          BlocProvider.of<ThemeCubit>(context).changeTheme();
                        }),
                  );
                },
              ),
            ),
            const Divider(),
            CustomListTile(
              title: "Logout",
              leadingIcon: Icons.logout,
              titleColor: Theme.of(context).primaryColor,
              onTap: () async {
                await logoutUser(context);
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    bool shouldLogout = await booleanBottomSheet(
            context: context,
            titleText: TextConstants.logoutTitle,
            boolTrueText: TextConstants.logoutText) ??
        false;
    if (shouldLogout) {
      BlocProvider.of<AuthCheckerCubit>(navigatorKey.currentContext!)
          .signOutUser();
    }
  }
}
