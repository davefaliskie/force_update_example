import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:force_update_example/src/features/updates/data/updates_repository.dart';
import 'package:force_update_example/src/features/updates/domain/update_status.dart';
import 'package:force_update_example/src/features/updates/presentation/mandatory_update_screen.dart';
import 'package:force_update_example/src/features/updates/presentation/optional_update_card.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updateStatusValue = ref.watch(deviceUpdateStatusProvider);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: updateStatusValue.when(
        loading: () => const CircularProgressIndicator.adaptive(),
        error: (e, s) => const Center(
          child: Text("There was a problem loading the app, please try again"),
        ),
        data: (updateStatus) {
          if (updateStatus == UpdateStatus.mandatory) {
            return const MandatoryUpdateScreen();
          }
          return const MyHomePage(title: 'Flutter Demo Home Page');
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const OptionalUpdateCard(),
            const Spacer(),
            Consumer(builder: (context, ref, child) {
              final AsyncValue<int> currentBuild =
                  ref.watch(deviceBuildProvider);
              return currentBuild.when(
                data: (value) {
                  return Text("Current build: $value");
                },
                loading: () {
                  return const CircularProgressIndicator();
                },
                error: (e, st) {
                  return Text("there was an error: $e");
                },
              );
            }),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
