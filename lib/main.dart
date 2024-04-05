import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_registro_screen.dart'; // Ajusta la ruta de importación

void main() async {
  // Código de inicialización de la aplicación
  WidgetsFlutterBinding.ensureInitialized();
  // Código de inicialización de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Ejecuta la aplicación
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: AuthScreen(), // Utiliza AuthScreen como la pantalla principal
    );
  }
}