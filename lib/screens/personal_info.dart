import 'package:flutter/material.dart';


class info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi primera app',
      home: Scaffold(
        appBar: AppBar(
          title: Text('¡Hola, mundo!'),
        ),
        body: Center(
          child: Text('¡Hola, mundo!'),
        ),
      ),
    );
  }
}
