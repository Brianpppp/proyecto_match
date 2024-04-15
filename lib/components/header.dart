import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Altura del encabezado
    final double headerHeight = MediaQuery.of(context).size.width * 0.16;

    return Container(
      height: headerHeight,
      // Color de fondo del encabezado
      color: Color.fromRGBO(255, 169, 209, 1),
      child: Center(
        child: Image.asset(
          'match2.png', // Ruta de la imagen del logo en assets
          height: headerHeight, // Tamaño de la imagen relativo a la altura del encabezado
          fit: BoxFit.contain, // Ajustar la imagen dentro del contenedor
        ),
      ),
    );
  }
}
