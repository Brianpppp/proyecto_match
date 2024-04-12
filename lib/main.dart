import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolist_firebase/screens/home_screen.dart';
import 'package:todolist_firebase/screens/menu_card.dart';
import 'package:todolist_firebase/screens/store_points.dart';
import 'package:todolist_firebase/screens/user.dart';
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
      debugShowCheckedModeBanner: false, // Esta línea oculta el banner de "Debug"
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: AuthScreen(), // Utiliza AuthScreen como la pantalla principal
      routes: {
        '/home_screen': (context)=> HomeScreen(),
        '/menu': (context) => MenuPage(),
        '/store_points': (context) => StorePage(),
        '/user': (context) => UserPage(),
      },
    );
  }
}

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      home: HomeScreen(),
    );
  }
}*/