import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user.dart';

class UserService {
  final _instance = FirebaseFirestore.instance;
  static const _collectionPath = 'users';

  Future<User> create(User user) async {
    await _instance.collection(_collectionPath).doc(user.id).set(user.toJson());
    return user;
  }

  Future<User?> get(String id) async {
    final ret = await _instance.collection(_collectionPath).doc(id).get();
    if (!ret.exists) {
      return null;
    }
    return User.fromJson({'id': ret.id, ...ret.data()!});
  }

  Future<User> update(User user) async {
    await _instance
        .collection(_collectionPath)
        .doc(user.id)
        .update(user.toJson());
    return user;
  }

  Future<List<User>> getAll() async {
    final querySnapshot = await _instance.collection(_collectionPath).get();
    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    final users = querySnapshot.docs
        .map((user) => User.fromJson({'id': user.id, ...user.data()}));
    return users.toList();
  }
}
