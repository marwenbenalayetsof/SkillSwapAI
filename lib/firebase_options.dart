import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => web;

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDa2jsjNS1oEf3fgt0CBeHRTqx2jnbknGs',
    appId: '1:615506714960:web:a4cb15e0e80c5c4a3fc562',
    messagingSenderId: '615506714960',
    projectId: 'flutter-test-12345',
    authDomain: 'flutter-test-12345.firebaseapp.com',
    storageBucket: 'flutter-test-12345.appspot.com',
    measurementId: 'G-6JN5R5S5SW',
  );
}
