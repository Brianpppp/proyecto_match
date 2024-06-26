// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
    apiKey: 'AIzaSyDXtnZjCD_j_PwlKXYwh23tCewmsqs5ecA',
    appId: '1:234622299002:web:925709c3ee8ffd56f884c3',
    messagingSenderId: '234622299002',
    projectId: 'listatareas-7d7b9',
    authDomain: 'listatareas-7d7b9.firebaseapp.com',
    storageBucket: 'listatareas-7d7b9.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDrDqXRzwP7Xzf-bZuOYE7N693_LBTH-iM',
    appId: '1:234622299002:android:741f37649b28cdfaf884c3',
    messagingSenderId: '234622299002',
    projectId: 'listatareas-7d7b9',
    storageBucket: 'listatareas-7d7b9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDE-qq5oko-xfjBNypdaVX75JVpS9VvNBo',
    appId: '1:234622299002:ios:f1f4154d8366e55cf884c3',
    messagingSenderId: '234622299002',
    projectId: 'listatareas-7d7b9',
    storageBucket: 'listatareas-7d7b9.appspot.com',
    iosBundleId: 'com.example.todolistFirebase',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDE-qq5oko-xfjBNypdaVX75JVpS9VvNBo',
    appId: '1:234622299002:ios:688364fe12adc9b6f884c3',
    messagingSenderId: '234622299002',
    projectId: 'listatareas-7d7b9',
    storageBucket: 'listatareas-7d7b9.appspot.com',
    iosBundleId: 'com.example.todolistFirebase.RunnerTests',
  );
}
/*rules_version = '2';
service cloud.firestore {
match /databases/{database}/documents {
// Reglas para la colección 'todos'
match /todos/{document=**} {
allow read, write: if request.auth != null && request.auth.uid == resource.data['UID de usuario'];
}
}
}
*/

/*service cloud.firestore {
match /databases/{database}/documents {
// Permitir leer y escribir en todas las colecciones
match /{document=**} {
allow read, write: if true;
}
}
}*/


