import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:provider/provider.dart';

import 'ProviderPractice.dart';
import 'RiverpodPractice.dart';

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

void main() {
  // WidgetsFlutterBinding.ensureInitialized();

  // _firebaseMessaging.configure(
  //   onMessage: (Map<String, dynamic> message) async {
  //     print("onMessage: $message");
  //     // _showItemDialog(message);
  //   },
  //   onBackgroundMessage: myBackgroundMessageHandler,
  //   onLaunch: (Map<String, dynamic> message) async {
  //     print("onLaunch: $message");
  //     // _navigateToItemDetail(message);
  //   },
  //   onResume: (Map<String, dynamic> message) async {
  //     print("onResume: $message");
  //     // _navigateToItemDetail(message);
  //   },
  // );
  runApp(
    ProviderScope(child: MyApp())
  );
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("hoge Handling a background message: ${message.messageId}");
}



class MyApp extends StatelessWidget {
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    return MaterialApp(
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => HomePage(),
        '/provider': (BuildContext context) => ProviderPractice(),
        '/riverpod': (BuildContext context) => RiverpodPractice()
      },
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              child: const Text('using Provider'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed('/provider');
              },
            ),
            RaisedButton(
              child: const Text('using Riverpod'),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushNamed('/riverpod');
              },
            ),
          ],
        ),
      )
    );
  }
}
