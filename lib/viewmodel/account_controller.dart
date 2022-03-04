import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final accountProvider =
    StateNotifierProvider.autoDispose<AccountController, User?>(
        (ref) => AccountController());

class AccountController extends StateNotifier<User?> {
  AccountController() : super(null);

  void fetchMyAccount() {
    state = FirebaseAuth.instance.currentUser;
  }

  void setUser(User? user) {
    try {
      state = user;
    } catch (e) {
      print('error occurs: $e');
    }
    if (kDebugMode) {
      print('set user: $user');
    }
  }

  void logout() {
    state = null;
  }
}
