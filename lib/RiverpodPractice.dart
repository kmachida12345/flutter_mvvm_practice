import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// We create a "provider", which will store a value (here "Hello world").
// By using a provider, this allows us to mock/override the value exposed.
final counterProvider =
    ChangeNotifierProvider((ref) => _RiverpodPracticeCounter());

final textProvider = ChangeNotifierProvider((ref) => _TextProvider());

// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
class RiverpodPractice extends ConsumerWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthScreen();
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

  }
}

class _RiverpodPracticePageFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
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

class _TextProvider extends ChangeNotifier {
  String _email = '';
  String _password = '';

  String get email => _email;

  String get password => _password;

  set email(value) {
    _email = value;
  }

  set password(value) {
    _password = value;
  }

}

class TestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('testdesu').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              // shrinkWrap: true,
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return new ListTile(
                  title: new Text(document['fuga']),
                  subtitle: new Text(document['hoge'].toString()),
                );
              }).toList(),
            );
        }
      },
    );
  }
}

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return FugaScreen();
        }
        return HogeScreen();
      },
    );
  }
}

class HogeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> trySubmit() async {
      final auth = FirebaseAuth.instance;
      debugPrint('hoge email=${context.read(textProvider).email}, pass=${context.read(textProvider).password}');
      // if (auth.isSignInWithEmailLink('hoge')) {
      //   final result = await auth.signInWithEmailAndPassword(email: context
      //       .read(textProvider)
      //       .email, password: context
      //       .read(textProvider)
      //       .password);
      //   print('hoge${result.user.uid}');
      // } else {
        final result = await auth.createUserWithEmailAndPassword(email: context
            .read(textProvider)
            .email, password: context
            .read(textProvider)
            .password);
        print('hoge${result.user.uid}');
      // }
    }
    return Scaffold(
      appBar: AppBar(title: Text('auth'),),
      body: Center(
          child: Column(
            children: [
              Text('hoge'),
              TextFormField(
                decoration: InputDecoration(labelText: 'email'),
                onSaved: (newValue) {
                  debugPrint('hoge newValue=$newValue');
                },
                onChanged: (value) {
                  context
                      .read(textProvider)
                      .email = value;
                  debugPrint('hoge email newvalue=$value');
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'password'),
                obscureText: true,
                onSaved: (newValue) {
                  debugPrint('hoge newValue=$newValue');
                  context
                      .read(textProvider)
                      .password = newValue;
                },
                onChanged: (value) {
                  debugPrint('hoge pass newvalue=$value');
                  context
                      .read(textProvider)
                      .password = value;
                },
              ),
              RaisedButton(onPressed: () {
                trySubmit();
              },
              )
            ],
          )
      ),
    );
  }
}

class FugaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> addUser() {
      CollectionReference users =
      FirebaseFirestore.instance.collection('testdesu');

      return users
          .add({
        'hoge': 'hoge ${context
            .read(counterProvider)
            .counter}',
        'fuga': 'fuga',
        'age': 1
      })
          .then((value) => print('hoge user added.'))
          .catchError((error) => print('hoge failed. $error'));
    }

    return Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Consumer(builder: (context, watch, child) {
            return Text('${watch(counterProvider).counter}');
          }),
          RaisedButton(
            child: Text('add data'),
            color: Colors.orange,
            textColor: Colors.white,
            onPressed: addUser,
          ),
          Expanded(child: TestList())
        ],
      ),
      floatingActionButton: _RiverpodPracticePageFab(),
    );
  }

}