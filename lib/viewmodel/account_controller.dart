import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/user_service.dart';
import '../model/user.dart' as my;

final accountProvider =
    StateNotifierProvider.autoDispose<AccountController, my.User?>(
        (ref) => AccountController());

class AccountController extends StateNotifier<my.User?> {
  AccountController() : super(null);
  final _userService = UserService();

  void fetchMyAccount() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      state = my.User.fromAuth(currentUser);
    }
  }

  Future<bool> createIfAbsent(User user) async {
    try {
      final myUser = my.User.fromAuth(user);
      final myDoc = await _userService.get(user.uid);
      if (myDoc == null) {
        await _userService.create(myUser);
        state = myUser;
      } else {
        state = myDoc;
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  void setUser(my.User? user) {
    try {
      state = user;
    } catch (e) {
      if (kDebugMode) {
        print('error occurs: $e');
      }
    }
    if (kDebugMode) {
      print('set user: $user');
    }
  }

  void logout() {
    state = null;
  }
}
