import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  String id;
  String name;
  Timestamp createdAt;
  Timestamp updatedAt;
  String photoUrl;
  DocumentReference userRef;

  User({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.photoUrl,
    required this.userRef,
  });

  factory User.fromAuth(auth.User authUser) {
    return User(
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      id: authUser.uid,
      name: authUser.displayName ?? 'ゲストユーザー',
      photoUrl: authUser.photoURL ?? '',
      userRef: FirebaseFirestore.instance.doc('users/${authUser.uid}'),
    );
  }

  factory User.fromJson(Map<String, Object?> json) {
    var id = json['id'] as String? ?? '';
    return User(
      createdAt: json['created_at'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updated_at'] as Timestamp? ?? Timestamp.now(),
      name: json['name'] as String? ?? '',
      id: id,
      photoUrl: json['photo_url'] as String? ?? '',
      userRef: json['user_ref'] as DocumentReference? ??
          FirebaseFirestore.instance.doc('users/$id'),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
      'photo_url': photoUrl,
      'user_ref': userRef
    };
  }
}
