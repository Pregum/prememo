import 'package:flutter/material.dart';
import 'package:prememo/main.dart';
import 'package:prememo/view/auth_loading/auth_loading_page.dart';
import 'package:prememo/view/content/content_create_page.dart';
import 'package:prememo/view/main/main_page.dart';

import 'view/sign_in/sign_in_page.dart';

class RouterPath {
  static const rootPath = '/';
  static const mainPath = '/main';
  static const contentCreatePath = '/content_create';
  static const signInPath = '/sign_in';
  static const signUpPath = '/sign_up';
  static const authLoadingPath = '/auth_loading';
}

class RouterGenerator {
  static Route<Object> generateRoute(RouteSettings settings) {
    // 引数が必要なページの場合使用する
    // final args = settings.arguments;

    switch (settings.name) {
      case RouterPath.rootPath:
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => const MyHomePage(title: 'prememo'),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );
      case RouterPath.authLoadingPath:
        return MaterialPageRoute(builder: (_) => const AuthLoadingPage());
      case RouterPath.mainPath:
        return MaterialPageRoute(builder: (_) => const MainPage());
      case RouterPath.contentCreatePath:
        return MaterialPageRoute(builder: (_) => const ContentCreatePage());
      case RouterPath.signInPath:
        return MaterialPageRoute(builder: (_) => const SignInPage());
      case RouterPath.signUpPath:

      default:
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'default page.'));
    }
  }
}
