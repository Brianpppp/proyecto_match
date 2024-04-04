import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Altura del encabezado
      color: Color.fromRGBO(255, 169, 209, 1), // Establecer el color de fondo
      child: Center(
        child: Image.asset(
          'assets/logo.png', // Ruta de la imagen del logo en assets
          height: 80, // Altura del logo
          fit: BoxFit.contain, // Ajustar la imagen dentro del contenedor
        ),
      ),
    );
  }
}
