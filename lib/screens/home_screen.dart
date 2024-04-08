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
          width: 240, // Ancho del cuadrado
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
      backgroundColor: Colors.pink,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(),
          Container(
            color: Color.fromRGBO(255, 169, 209, 1.0),
            child: Text(
              'Ready to find love tonight?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageWidget(),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          // Acción a realizar al presionar el botón "X"
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.whatshot),
                        onPressed: () {
                          // Acción a realizar al presionar el botón de "Fuego"
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.favorite),
                        onPressed: () {
                          // Acción a realizar al presionar el botón del "Corazón"
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Footer(),
        ],
      ),
    );
  }
}
