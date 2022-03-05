import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:prememo/model/content.dart';
import 'package:prememo/router.dart';
import 'package:prememo/viewmodel/account_controller.dart';
import 'package:prememo/viewmodel/content_controller.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('メインページ'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.create),
        onPressed: () {
          contentController.setContent(Content.initialize());
          Navigator.of(context).pushNamed(RouterPath.contentCreatePath);
        },
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(account?.name ?? 'no'),
                accountEmail: null, // const Text(''),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: Colors.white,
                  // child: Text(account?.id ?? 'none'),
                  // child:  NetworkImage(account?.photoUrl)
                  backgroundImage: NetworkImage(account!.photoUrl),
                ),
                currentAccountPictureSize: const Size(50, 50),
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
              ListTile(
                leading: const Icon(Icons.manage_accounts),
                title: const Text('プロフィール'),
                onTap: () {
                  Navigator.of(context).pushNamed(RouterPath.profilePath);
                },
              ),
            ],
          ),
        ),
      ),
      body: MasonryGridView.count(
        itemCount: 30,
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemBuilder: (context, index) {
          return Hero(
            tag: 'content_$index',
            flightShuttleBuilder: _flightShuttleBuilder,
            child: Material(
              child: InkWell(
                onTap: () {
                  final contentController = ref.watch(contentProvider.notifier);
                  contentController.setContent(
                    Content(
                      content: 'this index $index...',
                      id: 'content_$index',
                      title: 'title $index',
                      createdAt: Timestamp.now(),
                      updatedAt: Timestamp.now(),
                    ),
                  );
                  Navigator.of(context).pushNamed(RouterPath.contentCreatePath);
                },
                child: SizedBox(
                  height: (index % 5 + 1) * 100,
                  child: Center(
                    child: Text(
                      index.toString(),
                    ),
                  ),
                ),
              ),
              color: Colors.greenAccent,
            ),
          );
        },
      ),
    );
  }
}
