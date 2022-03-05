import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  String id;
  String name;
  Timestamp createdAt;
  Timestamp updatedAt;
  String photoUrl;

  User({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.photoUrl,
  });

  factory User.fromAuth(auth.User authUser) {
    return User(
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      id: authUser.uid,
      name: authUser.displayName ?? 'ゲストユーザー',
      photoUrl: authUser.photoURL ?? '',
    );
  }

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      createdAt: json['created_at'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updated_at'] as Timestamp? ?? Timestamp.now(),
      name: json['name'] as String? ?? '',
      id: json['id'] as String? ?? '',
      photoUrl: json['photo_url'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
      'photo_url': photoUrl,
    };
  }
}
