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
  final _titleEditingController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();
    _textEditingController.addListener(() {
      _handleContentChanged();
    });

    final content = ref.read(contentProvider);
    _titleEditingController.text = content.title;
    _titleEditingController.addListener(() {
      _handleTitleChanged();
    });
  }

  void _handleTitleChanged() {
    final contentNotifier = ref.watch(contentProvider.notifier);
    final updatedContent = contentNotifier.state
      ..title = _titleEditingController.text;
    contentNotifier.setContent(updatedContent);
  }

  void _handleContentChanged() {
    final contentNotifier = ref.watch(contentProvider.notifier);
    print('before content: ${contentNotifier.state}');
    final updatedContent = contentNotifier.state
      ..content = _textEditingController.text;

    contentNotifier.setContent(updatedContent);
    print('after content: ${contentNotifier.state}');
  }

  @override
  Widget build(BuildContext context) {
    final content = ref.watch(contentProvider);
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
              try {
                await contentService.create(content);
                final snackbar = SnackBar(
                    content: Text('作成しました！ -- id: ${content.id} \u{1F600}'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
                Navigator.of(context).pop();
              } catch (e) {
                const snackbar = SnackBar(content: Text('作成に失敗しました\u{1F600}'));
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }
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
                      child: Material(
                        // hero inside need material.
                        // ref: https://stackoverflow.com/questions/68599745/no-material-widget-found-hero-animation-is-not-working-with-textfield
                        type: MaterialType.transparency,
                        child: TextField(
                          controller: _titleEditingController,
                          maxLength: null,
                          maxLines: null,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context).primaryColor),
                            ),
                          ),
                        ),
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
    _titleEditingController.dispose();
    super.dispose();
  }
}
