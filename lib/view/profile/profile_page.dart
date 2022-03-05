import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterfire_ui/auth.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileScreen(
        providerConfigs: [
          GoogleProviderConfiguration(
            clientId: dotenv.get('GOOGLE_SIGN_IN_CLIEND_ID'),
          )
        ],
        avatarSize: 24,
      ),
    );
  }
}
