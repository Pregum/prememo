import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prememo/service/content_service.dart';
import 'package:prememo/viewmodel/content_controller.dart';

import '../../model/content.dart';

class ContentCreatePage extends ConsumerStatefulWidget {
  const ContentCreatePage({Key? key}) : super(key: key);

  @override
  _ContentCreatePageState createState() => _ContentCreatePageState();
}

class _ContentCreatePageState extends ConsumerState<ContentCreatePage> {
  @override
  Widget build(BuildContext context) {
    final contentController = ref.watch(contentProvider);
    final TextStyle style = Theme.of(context).textTheme.titleMedium!.copyWith(
          fontSize: 24,
          fontWeight: FontWeight.normal,
        );
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              final contentService = ref.watch(contentServiceProvider);
              await contentService.create(Content.initialize());
            },
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Hero(
            tag: contentController.id,
            child: Text(
              contentController.title,
              style: style,
            ),
          ),
          Text(contentController.content),
        ],
      ),
    );
  }
}
