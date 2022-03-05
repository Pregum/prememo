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
  final _textEditingController = TextEditingController(text: '');

  final _contentProvider = StateProvider<Content>((_) => Content.initialize());

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      _handleContentChanged();
    });
  }

  void _handleContentChanged() {
    final contentNotifier = ref.watch(_contentProvider.notifier);
    print('before content: ${contentNotifier.state}');
    final updatedContent = contentNotifier.state
      ..content = _textEditingController.text;

    contentNotifier.state = updatedContent;
    print('after content: ${contentNotifier.state}');
  }

  @override
  Widget build(BuildContext context) {
    final content = ref.watch(_contentProvider);
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
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: Column(
                children: <Widget>[
                  Center(
                    child: Hero(
                      tag: content.id,
                      child: Text(
                        content.title,
                        style: style,
                      ),
                    ),
                  ),
                  Text('作成日時: ${content.createdAt.toDate().toPrettyStr()}'),
                  Text('最終更新日時: ${content.updatedAt.toDate().toPrettyStr()}'),
                  const Divider(),
                  TextField(
                    maxLength: null,
                    maxLines: null,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                    ),
                    controller: _textEditingController,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
