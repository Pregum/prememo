import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/content.dart';

final contentProvider =
    StateNotifierProvider.autoDispose<ContentController, Content>(
        (ref) => ContentController());

class ContentController extends StateNotifier<Content> {
  ContentController() : super(Content.initialize());

  void setContent(Content content) {
    state = content;
  }
}
