import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpopchat/core/routes/app_routes.dart';
import 'package:kpopchat/business_logic/auth_checker_cubit/auth_checker_cubit.dart';

class AuthCheckerScreen extends StatelessWidget {
  const AuthCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCheckerCubit>(context).checkUserAuth();
    return BlocListener<AuthCheckerCubit, AuthStates>(
        listener: (context, state) {
          if (state == AuthStates.loggedInState) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.dashboardScreen,
                // AppRoutes.virtualFriendsListScreen,
                (route) => false);
          } else if (state == AuthStates.loggedOutState) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.signInScreen, (route) => false);
          }
        },
        child: const Material(
          child: Center(child: CircularProgressIndicator()),
        ));
  }
}
