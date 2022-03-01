import 'package:cloud_firestore/cloud_firestore.dart';

class Content {
  String id;
  String title;
  String content;
  Timestamp createdAt;
  Timestamp updatedAt;

  Content({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Content.initialize() {
    return Content(
      id: 'id',
      title: 'this sample title',
      content: 'this sample content',
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
    );
  }

  factory Content.fromJson(Map<String, Object?> json) {
    return Content(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updated_at'] as Timestamp? ?? Timestamp.now(),
    );
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'content': content,
      'created_at': createdAt,
      'updated_at': FieldValue.serverTimestamp(),
    };
  }
}
