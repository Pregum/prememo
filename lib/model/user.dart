import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart' as auth;

class User {
  String id;
  String name;
  Timestamp createdAt;
  Timestamp updatedAt;

  User(
      {required this.id,
      required this.name,
      required this.createdAt,
      required this.updatedAt});

  factory User.fromAuth(auth.User authUser) {
    return User(
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      id: authUser.uid,
      name: authUser.displayName.toString(),
    );
  }

  factory User.fromJson(Map<String, Object?> json) {
    return User(
      createdAt: json['created_at'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updated_at'] as Timestamp? ?? Timestamp.now(),
      name: json['name'] as String? ?? '',
      id: json['id'] as String? ?? '',
    );
  }

  Map<String, Object?> toJson() {
    return {
      'created_at': createdAt,
      'updated_at': updatedAt,
      'name': name,
    };
  }
}
