import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthLoadingPage extends ConsumerStatefulWidget {
  const AuthLoadingPage({Key? key}) : super(key: key);

  @override
  _AuthLoadingPageState createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends ConsumerState<AuthLoadingPage> {
  @override
  Widget build(BuildContext context) {
    return Container();
    // return RegisterScreen(providerConfigs: providerConfigs);
  }
}
