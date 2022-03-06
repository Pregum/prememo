import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Content {
  String id;
  String title;
  String content;
  Timestamp createdAt;
  Timestamp updatedAt;
  DocumentReference? userRef;

  Content({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.userRef,
  });

  factory Content.initialize() {
    return Content(
      id: 'id',
      title: 'this sample title',
      content: 'this sample content',
      createdAt: Timestamp.now(),
      updatedAt: Timestamp.now(),
      userRef: null,
    );
  }

  factory Content.fromJson(Map<String, Object?> json) {
    return Content(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      title: json['title'] as String? ?? '',
      createdAt: json['created_at'] as Timestamp? ?? Timestamp.now(),
      updatedAt: json['updated_at'] as Timestamp? ?? Timestamp.now(),
      userRef: json['user_ref'] as DocumentReference?,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'title': title,
      'content': content,
      'created_at': createdAt,
      'updated_at': FieldValue.serverTimestamp(),
      'user_ref': userRef,
    };
  }

  @override
  String toString() {
    return 'id: $id, title: $title, content: $content, userRef: $userRef';
  }
}

extension ContentExt on DateTime {
  String toPrettyStr() {
    initializeDateFormatting('ja_JP');
    final formatted = DateFormat('yyyy年MM月dd日 HH:mm', 'ja');
    return formatted.format(this);
  }
}
