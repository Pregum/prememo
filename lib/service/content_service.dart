import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/content.dart';

final contentServiceProvider =
    Provider<ContentService>((_) => ContentService());

class ContentService {
  final instance = FirebaseFirestore.instance;
  static const collectionPath = 'contents';

  Future<Content> create(Content content) async {
    final ret = await instance.collection(collectionPath).add(content.toJson());
    content.id = ret.id;
    return content;
  }

  Future<void> update(Content content) async {
    await instance
        .collection(collectionPath)
        .doc(content.id)
        .update(content.toJson());
  }

  Future<Content> get(String id) async {
    final json = await instance.collection(collectionPath).doc(id).get();
    if (json.data() == null) {
      throw Exception('not found data.');
    }
    return Content.fromJson({'id': id, ...json.data()!});
  }

  Future<List<Content>> getAll() async {
    final querySnapshot = await instance.collection(collectionPath).get();
    if (querySnapshot.docs.isEmpty) {
      return [];
    }

    final contents = querySnapshot.docs.map(
      (contentJson) =>
          Content.fromJson({'id': contentJson.id, ...contentJson.data()}),
    );
    return contents.toList();
  }
}
