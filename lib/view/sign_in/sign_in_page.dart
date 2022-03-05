import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final providerConfigs = [
    GoogleProviderConfiguration(
      clientId: dotenv.get('GOOGLE_SIGN_IN_CLIEND_ID'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // ref: https://firebase.flutter.dev/docs/ui/auth/integrating-your-first-screen
    return SignInScreen(
      providerConfigs: providerConfigs,
      // ref: http://blog.wafrat.com/using-flutterfire_ui-with-unit-tests/
      footerBuilder: (context, _) => OutlinedButton(
        onPressed: () async => await FirebaseAuth.instance.signInAnonymously(),
        child: const Text('ゲストとしてログイン'),
      ),
      auth: FirebaseAuth.instance,
    );
  }
}
