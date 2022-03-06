import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prememo/model/content.dart';
import 'package:prememo/router.dart';
import 'package:prememo/service/content_service.dart';
import 'package:prememo/viewmodel/account_controller.dart';
import 'package:prememo/viewmodel/content_controller.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

final contentFutureProvider = FutureProvider.autoDispose<List<Content>>((ref) {
  final cp = ref.watch(contentServiceProvider);
  final account = ref.watch(accountProvider);
  return cp.getByRef(account!.userRef);
});

class _MainPageState extends ConsumerState<MainPage> {
  // ref: https://github.com/flutter/flutter/issues/30647

  Widget _flightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final account = ref.watch(accountProvider);
    final contentController = ref.watch(contentProvider.notifier);
    final cfp = ref.watch(contentFutureProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('メインページ'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () async {
          contentController.setContent(Content.initialize());
          await Navigator.of(context).pushNamed(RouterPath.contentCreatePath);
          ref.refresh(contentFutureProvider);
        },
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(account?.name ?? 'no name'),
                accountEmail: null, // const Text(''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(account!.photoUrl),
                ),
                currentAccountPictureSize: const Size(50, 50),
              ),
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text('プロフィール'),
                onTap: () {
                  Navigator.of(context).pushNamed(RouterPath.profilePath);
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('ログアウト'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  final ac = ref.watch(accountProvider.notifier);
                  ac.logout();
                  await Navigator.of(context)
                      .popAndPushNamed(RouterPath.rootPath);
                },
              ),
            ],
          ),
        ),
      ),
      body: cfp.when(
        data: (data) {
          if (data.isEmpty) {
            return Container(
              color: Colors.white,
              child: const Text('右下のボタンから新しい記事を作成しましょう！'),
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              ref.refresh(contentFutureProvider);
            },
            child: MasonryGridView.count(
              itemCount: data.length,
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              itemBuilder: (context, index) {
                final currData = data[index];
                return Hero(
                  tag: currData.id,
                  flightShuttleBuilder: _flightShuttleBuilder,
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: Material(
                      child: InkWell(
                        onLongPress: () => _showMenu(currData),
                        onTap: () async {
                          final contentController =
                              ref.watch(contentProvider.notifier);
                          contentController.setContent(
                            currData,
                          );
                          await Navigator.of(context)
                              .pushNamed(RouterPath.contentCreatePath);
                        },
                        child: SizedBox(
                          height: (index % 5 + 1) * 100,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                currData.title,
                              ),
                            ),
                          ),
                        ),
                      ),
                      color: Colors.greenAccent,
                    ),
                  ),
                );
              },
            ),
          );
        },
        error: (error, stack) => Container(),
        loading: () => Container(
          color: Colors.white,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Future<void> _showMenu(Content selectedData) async {
    var result = await showModalBottomSheet<int>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('削除'),
              onTap: () => Navigator.of(context).pop(1),
            )
          ],
        );
      },
    );

    if (result == null) {
      return;
    }

    final contentService = ref.watch(contentServiceProvider);
    await contentService.delete(selectedData);

    final snackbar = SnackBar(
      content: Text('削除されました -- $selectedData'),
      action: SnackBarAction(
        label: '元に戻す',
        onPressed: () async {
          await contentService.set(selectedData);
          final undoSnack = SnackBar(
            content: Text('元に戻しました -- $selectedData'),
          );
          ScaffoldMessenger.of(context).showSnackBar(undoSnack);
          ref.refresh(contentFutureProvider);
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
    ref.refresh(contentFutureProvider);
  }
}
