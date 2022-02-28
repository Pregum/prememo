import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/content.dart';

final contentProvider = StateNotifierProvider<ContentController, Content>(
    (ref) => ContentController());

class ContentController extends StateNotifier<Content> {
  ContentController()
      : super(Content(content: 'no content', id: '', title: 'no title'));

  void setContent(Content content) {
    state = content;
  }
}
