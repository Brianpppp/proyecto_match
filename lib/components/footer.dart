import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white, // Fondo blanco
      selectedItemColor: Colors.grey[800], // Color oscuro para los iconos seleccionados
      unselectedItemColor: Colors.grey[600], // Color para los iconos no seleccionados
      type: BottomNavigationBarType.fixed, // Para alinear los íconos verticalmente
      iconSize: 40,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.home),
            alignment: Alignment.center,
          ),
          label: '', // Etiqueta vacía
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.fastfood_sharp),
            alignment: Alignment.center,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.shopping_cart),
            alignment: Alignment.center,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.person),
            alignment: Alignment.center,
          ),
          label: '',
        ),
      ],
    );
  }
}
