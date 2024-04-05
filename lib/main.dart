import 'package:flutter/material.dart';
import 'package:proyecto_match/screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Aquí se deshabilita el mensaje
      title: 'Mi Aplicación',
      home: HomeScreen(),

    );
  }
}
