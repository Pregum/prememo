import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prememo/viewmodel/content_controller.dart';

class ContentCreatePage extends ConsumerStatefulWidget {
  const ContentCreatePage({Key? key}) : super(key: key);

  @override
  _ContentCreatePageState createState() => _ContentCreatePageState();
}

class _ContentCreatePageState extends ConsumerState<ContentCreatePage> {
  @override
  Widget build(BuildContext context) {
    final contentController = ref.watch(contentProvider);
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Hero(
          tag: contentController.id,
          child: Column(
            children: <Widget>[
              Text(contentController.title),
              Text(contentController.content),
            ],
          ),
        ),
      ),
    );
  }
}
