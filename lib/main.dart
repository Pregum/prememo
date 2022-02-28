import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:prememo/router.dart';
import 'package:prememo/viewmodel/counter_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const fileName = kDebugMode ? '.env.dev' : '.env.prod';
  await dotenv.load(fileName: fileName);
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: RouterGenerator.generateRoute,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  void _incrementCounter() {
    final counter = ref.watch(counterProvider.notifier);
    counter.increment();
  }

  @override
  Widget build(BuildContext context) {
    final counter = ref.watch(counterProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            ElevatedButton(
              onPressed: () {
                // ref: https://qiita.com/maria_mari/items/6502f8d6e45d693f9ead
                Navigator.of(context).pushNamed(RouterPath.mainPath);
              },
              child: const Text('move next page.'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(RouterPath.signInPath);
              },
              child: const Text('サインインはこちら'),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigator.of(context).pushNamed(RouterPath.signInPath);
                final userCredential =
                    await FirebaseAuth.instance.signInAnonymously();
                if (userCredential.user == null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('ログインエラー'),
                        content: const Text('ログインに失敗しました。'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                  return;
                }

                final snackbar = SnackBar(
                  content: Text('ログインしました！ -- ${userCredential.user?.uid}'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackbar);

                Navigator.of(context).pushNamed(RouterPath.mainPath);
              },
              child: const Text('ゲストの場合はこちら'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
