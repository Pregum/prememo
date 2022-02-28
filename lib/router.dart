import 'package:flutter/material.dart';
import 'package:prememo/main.dart';
import 'package:prememo/view/main_page.dart';

class RouterPath {
  static const rootPath = '/';
  static const mainPath = '/main';
}

class RouterGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // 引数が必要なページの場合使用する
    // final args = settings.arguments;

    switch (settings.name) {
      case RouterPath.rootPath:
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'hogehoge'));
      case RouterPath.mainPath:
        return MaterialPageRoute(builder: (_) => const MainPage());
      default:
        return MaterialPageRoute(
            builder: (_) => const MyHomePage(title: 'default page.'));
    }
  }
}
