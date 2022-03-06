import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prememo/view/sign_in/sign_in_page.dart';
import 'package:prememo/viewmodel/account_controller.dart';

import '../main/main_page.dart';

final streamProvider = StreamProvider.autoDispose<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

final shownProvider = StateProvider.autoDispose<bool>((ref) => false);

class AuthLoadingPage extends ConsumerStatefulWidget {
  const AuthLoadingPage({Key? key}) : super(key: key);

  @override
  _AuthLoadingPageState createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends ConsumerState<AuthLoadingPage> {
  @override
  Widget build(BuildContext context) {
    final sp = ref.watch(streamProvider);
    final myUser = ref.watch(accountProvider.notifier);

    return sp.when<Widget>(
      loading: () => const SignInPage(),
      error: (error, stack) => const Text('error'),
      data: (user) {
        if (user == null) {
          return const SignInPage();
        }

        return FutureBuilder(
            future: myUser.createIfAbsent(user),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                    color: Colors.white,
                    child: const Center(
                        child: CircularProgressIndicator.adaptive()));
              }
              _showSnackbar(context);
              return const MainPage();
            });
      },
    );
  }

  void _showSnackbar(BuildContext context) {
    final snackbar = SnackBar(
      content: Text('ログインしました！ -- ${FirebaseAuth.instance.currentUser?.uid}'),
    );
    // ref: https://stackoverflow.com/questions/45409565/flutter-setstate-or-markneedsbuild-called-when-widget-tree-was-locked
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      // ref: https://stackoverflow.com/questions/69330128/snackbar-showing-twice-due-to-stacked-screen-flutter-how-can-i-avoid-it
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });
  }
}
