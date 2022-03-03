import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prememo/view/sign_in/sign_in_page.dart';
import 'package:prememo/viewmodel/account_controller.dart';

import '../main/main_page.dart';

class AuthLoadingPage extends ConsumerStatefulWidget {
  const AuthLoadingPage({Key? key}) : super(key: key);

  @override
  _AuthLoadingPageState createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends ConsumerState<AuthLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SignInPage();
        }

        // ユーザー情報をproviderに設定
        final myUser = ref.watch(accountProvider.notifier);
        myUser.setUser(snapshot.data);
        _showSnackbar(context);
        return const MainPage();
      },
    );
  }

  void _showSnackbar(BuildContext context) {
    final snackbar = SnackBar(
      content: Text('ログインしました！ -- ${FirebaseAuth.instance.currentUser?.uid}'),
    );
    // ref: https://stackoverflow.com/questions/45409565/flutter-setstate-or-markneedsbuild-called-when-widget-tree-was-locked
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });
  }

  bool fetchIsFirstBoot() => false;
}
