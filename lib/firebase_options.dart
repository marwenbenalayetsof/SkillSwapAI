import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDa2jsjNS1oEf3fgt0CBeHRTqx2jnbknGs',
    appId: '1:492082878336:web:918f334f7760fe34b29365',
    messagingSenderId: '492082878336',
    projectId: 'flutter-test-12345',
    authDomain: 'flutter-test-12345.firebaseapp.com',
    storageBucket: 'flutter-test-12345.firebasestorage.app',
  );
}
