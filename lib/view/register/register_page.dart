import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final providerConfigs = [
    const EmailProviderConfiguration(),
    GoogleProviderConfiguration(
      clientId: dotenv.get('GOOGLE_SIGN_IN_CLIEND_ID'),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return RegisterScreen(
      providerConfigs: providerConfigs,
    );
  }
}
