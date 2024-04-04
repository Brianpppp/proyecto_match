import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          backgroundColor: Color.fromRGBO(255, 169, 209, 1),
          icon: Icon(Icons.home),
          label: '', // Establecer la etiqueta como una cadena vacía
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu),
          label: '',
        ),
      ],
    );
  }
}
