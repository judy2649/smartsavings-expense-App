import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDemoWebApiKey1234567890abcdefg',
    appId: '1:123456789012:web:abcd1234efgh5678ijkl',
    messagingSenderId: '123456789012',
    projectId: 'smart-savings-demo',
    authDomain: 'smart-savings-demo.firebaseapp.com',
    databaseURL: 'https://smart-savings-demo.firebaseio.com',
    storageBucket: 'smart-savings-demo.appspot.com',
    
    measurementId: 'G-DEMO1234567',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDemoAndroidKey123456789abcdef',
    appId: '1:123456789012:android:1234abcd5678efgh',
    messagingSenderId: '123456789012',
    projectId: 'smart-savings-demo',
    databaseURL: 'https://smart-savings-demo.firebaseio.com',
    storageBucket: 'smart-savings-demo.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDemoIOSKey12345678901234567890',
    appId: '1:123456789012:ios:abcd1234efgh5678ijkl',
    messagingSenderId: '123456789012',
    projectId: 'smart-savings-demo',
    databaseURL: 'https://smart-savings-demo.firebaseio.com',
    storageBucket: 'smart-savings-demo.appspot.com',
    iosBundleId: 'com.example.smartSavings',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDemoMacOSKey123456789012345678',
    appId: '1:123456789012:macos:abcd1234efgh5678ijkl',
    messagingSenderId: '123456789012',
    projectId: 'smart-savings-demo',
    databaseURL: 'https://smart-savings-demo.firebaseio.com',
    storageBucket: 'smart-savings-demo.appspot.com',
    iosBundleId: 'com.example.smartSavings.macos',
  );
}

