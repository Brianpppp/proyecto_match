import 'package:flutter/material.dart';
import 'package:proyecto_match/components/header.dart';
import 'package:proyecto_match/components/footer.dart';

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0), // Radio de borde para hacer los bordes redondeados
        child: Container(
          width: 300, // Ancho del cuadrado
          height: 280, // Alto del cuadrado
          color: Colors.transparent, // Color transparente para el fondo
          child: Image.asset(
            'assets/hamburguesa.jpg', // Ruta de la imagen en assets
            fit: BoxFit.cover, // Ajustar la imagen al cuadrado
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Aquí se deshabilita el mensaje
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Para asegurarte de que el Header ocupe todo el ancho
          children: [
            Header(), // Agrega el componente Header
            Expanded(
              child: Container(
                color: Color.fromRGBO(255, 169, 209, 1.0), // Color de fondo
                child: Center(
                  child: ImageWidget(),
                ),
              ),
            ),
            Footer(), // Agrega el componente Footer
          ],
        ),
      ),
    );
  }
}
