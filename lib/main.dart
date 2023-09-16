import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:kpopchat/business_logic/chat_cubit/chat_cubit.dart';
import 'package:kpopchat/business_logic/internet_checker_cubit.dart';
import 'package:kpopchat/business_logic/virtual_friends_cubit/virtual_friends_list_cubit.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/business_logic/theme_cubit.dart';
import 'package:kpopchat/business_logic/auth_checker_cubit/auth_checker_cubit.dart';
import 'core/firebase/firebase_setup.dart';
import 'core/routes/route_generator.dart';
import 'core/utils/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseSetup().initializeFirebase();
  await setUpLocator();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthCheckerCubit()),
          BlocProvider(create: (context) => ThemeCubit()),
          BlocProvider(create: (context) => VirtualFriendsListCubit(locator())),
          BlocProvider(create: (context) => ChatCubit(locator())),
          BlocProvider(
              create: (context) => InternetConnectivityCubit(
                  locator<InternetConnectionChecker>())),
        ],
        child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return BlocBuilder<ThemeCubit, ThemeData>(
                builder: (context, themeToUse) {
              BlocProvider.of<ThemeCubit>(context).getTheme();
              return MaterialApp(
                navigatorKey: navigatorKey,
                debugShowCheckedModeBanner: false,
                navigatorObservers: [
                  FirebaseAnalyticsObserver(
                      analytics: locator<FirebaseAnalytics>())
                ],
                onGenerateRoute: onGenerateRoute,
                initialRoute: AppRoutes.authCheckerScreen,
                builder: (context, widget) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: widget!,
                  );
                },
                theme: themeToUse,
              );
            });
          },
        ));
  }
}
