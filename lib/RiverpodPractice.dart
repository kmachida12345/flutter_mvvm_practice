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

final firebaseProvider =
    ChangeNotifierProvider((ref) => _FirebaseFirestoreProvider());

// final TextEditingController _emailController = TextEditingController();
// final TextEditingController _passwordController = TextEditingController();

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

class _FirebaseFirestoreProvider extends ChangeNotifier {
  DocumentReference _reference;

  DocumentReference get reference => _reference;

  set reference(value) {
    _reference = value;
  }
}

class TestList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: context
          .read(firebaseProvider)
          .reference
          .collection('data')
          .snapshots(),
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
          context.read(firebaseProvider).reference = FirebaseFirestore.instance
              .collection('version')
              .doc('1')
              .collection('user')
              .doc(FirebaseAuth.instance.currentUser.uid);
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
    Future<void> register() async {
      final auth = FirebaseAuth.instance;
      debugPrint(
          'hoge email=${context.read(textProvider).email}, pass=${context.read(textProvider).password}');
      final result = await auth.createUserWithEmailAndPassword(
          email: context.read(textProvider).email,
          password: context.read(textProvider).password);
      print('hoge${result.user.uid}');

      Map<String, String> initialData = {'email': result.user.email};
      FirebaseFirestore.instance
          .collection('version')
          .doc('1')
          .collection('user')
          .doc(result.user.uid)
          .set(initialData);
    }

    Future<void> login() async {
      final auth = FirebaseAuth.instance;
      final result = await auth.signInWithEmailAndPassword(
          email: context.read(textProvider).email,
          password: context.read(textProvider).password);
      print('hoge${result.user.uid}');
      context.read(firebaseProvider).reference = FirebaseFirestore.instance
          .collection('version')
          .doc('1')
          .collection('user')
          .doc(result.user.uid);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('auth'),
      ),
      body: Center(
          child: Column(
        children: [
          Text('hoge'),
          TextFormField(
            decoration: InputDecoration(labelText: 'email'),
            // controller: _emailController,
            onSaved: (newValue) {
              debugPrint('hoge newValue=$newValue');
            },
            onChanged: (value) {
              context.read(textProvider).email = value;
              debugPrint('hoge email newvalue=$value');
            },
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'password'),
            obscureText: true,
            // controller: _passwordController,
            onSaved: (newValue) {
              debugPrint('hoge newValue=$newValue');
              context.read(textProvider).password = newValue;
            },
            onChanged: (value) {
              debugPrint('hoge pass newvalue=$value');
              context.read(textProvider).password = value;
            },
          ),
          RaisedButton(
            child: Text('register'),
            onPressed: () {
              register();
            },
          ),
          RaisedButton(
              child: Text('login'),
              onPressed: () {
                login();
              })
        ],
      )),
    );
  }
}

class FugaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<void> addUser() {
      CollectionReference users =
          context.read(firebaseProvider).reference.collection('data');

      return users
          .add({
            'hoge': 'hoge ${context.read(counterProvider).counter}',
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
          Expanded(child: TestList()),
          RaisedButton(
              child: Text('logout'),
              onPressed: () {
                _logout();
              })
        ],
      ),
      floatingActionButton: _RiverpodPracticePageFab(),
    );
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
