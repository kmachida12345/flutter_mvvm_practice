import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
final counterProvider = ChangeNotifierProvider((ref) => _RiverpodPracticeCounter());

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class RiverpodPractice extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Example')),
        body: Center(
          child: Text('${watch(counterProvider).counter}'),
        ),
        floatingActionButton: _RiverpodPracticePageFab(),
      ),
    );
  }
}

class _RiverpodPracticePageFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed:() {
        context.read(counterProvider).incrementCounter();
      },
      tooltip: 'Increment',
      child: Icon(Icons.add),
    );
  }
}

class _RiverpodPracticeCounter extends ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;

  void incrementCounter() {
    this._counter++;
    notifyListeners();
  }
}
