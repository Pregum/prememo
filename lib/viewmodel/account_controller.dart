import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountProvider = StateNotifierProvider<AccountController, User?>(
    (ref) => AccountController());

class AccountController extends StateNotifier<User?> {
  AccountController() : super(null);

  void setUser(User user) {
    state = user;
  }

  void logout() {
    state = null;
  }
}
