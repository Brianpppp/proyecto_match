import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../components/header.dart';



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
    return Scaffold(
      backgroundColor: Colors.pink, // Establece el color de fondo rosa
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(),
          Container(
            color: Color.fromRGBO(255, 169, 209, 1.0), // Color de fondo del texto personalizado
            child: Text(
              'Ready to ',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold, // Agrega negrilla al texto
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0), // Color de fondo personalizado
              child: Center(
                child: ImageWidget(),
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
