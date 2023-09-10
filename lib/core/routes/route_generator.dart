import 'package:flutter/cupertino.dart';
import 'package:kpopchat/data/models/virtual_friend_model.dart';
import 'package:kpopchat/presentation/screens/auth_checker_screen.dart';
import 'package:kpopchat/presentation/screens/chat_screen/chat_screen.dart';
import 'package:kpopchat/presentation/screens/menu_screen.dart';
import 'package:kpopchat/presentation/screens/sign_in_screen.dart';
import 'package:kpopchat/presentation/screens/virtual_friends_list/virtual_friends_list_screen.dart';
import 'app_routes.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  Object? argument = settings.arguments;
  switch (settings.name) {
    case AppRoutes.authCheckerScreen:
      return CupertinoPageRoute(
          builder: (context) => const AuthCheckerScreen());
    case AppRoutes.signInScreen:
      return CupertinoPageRoute(builder: (context) => const SignInScreen());
    case AppRoutes.virtualFriendsListScreen:
      return CupertinoPageRoute(
          builder: (context) => const VirtualFriendsListScreen());
    case AppRoutes.menuScreen:
      return pageRouteBuilder(screen: const MenuScreen());
    case AppRoutes.chatScreen:
      return CupertinoPageRoute(
          builder: (context) =>
              ChatScreen(virtualFriend: argument as VirtualFriendModel));
    default:
      return CupertinoPageRoute(builder: (context) => const SignInScreen());
  }
}

pageRouteBuilder({required Widget screen}) {
  return PageRouteBuilder(
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, animation, secondaryAnimation) => screen,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = const Offset(-1.0, 0.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);
      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}
