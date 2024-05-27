import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String nombre;
  final double precio;
  final String apodo;
  final String descripcion;
  final String url;
  final String etiquetaSeleccionada;
  final List<String> etiqueta;

  const FoodCard({
    Key? key,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.url,
    required this.etiquetaSeleccionada,
    required this.apodo,
    required this.etiqueta,
  }) : super(key: key);

  @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;
      final double cardWidth = screenWidth * 0.4;
      final double cardHeight = screenHeight * 0.35;
      final double horizontalPadding = screenWidth * 0.06;
      final double verticalPadding = screenHeight * 0.01;
      final double nameFontSize = screenWidth * 0.05; // Reduje el tamaño de la fuente del nombre
      final double priceFontSize = screenWidth * 0.04;

    return Container(
      margin: EdgeInsets.all(20.0), // Margen en todos los lados
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white, // Color de fondo rojo
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.0),
        child: SizedBox(
          width: cardWidth,
          height: cardHeight,
          child: SingleChildScrollView(
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(40.0), // Margen en todos los lados dentro del contenedor
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    apodo,
                    style: TextStyle(
                      fontSize: nameFontSize,
                      color: Colors.black,
                      fontWeight: FontWeight.bold, // Añade la fuente negrita aquí
                    ),
                  ),
                  Text(
                    nombre,
                    style: TextStyle(fontSize: nameFontSize),
                  ),
                  SizedBox(height: 10.0), // Margen vertical adicional entre elementos
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      url,
                      width: cardWidth * 1.2, // Aumentando el tamaño de la imagen
                      height: cardHeight * 0.6, // Aumentando el tamaño de la imagen
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 10.0), // Margen vertical adicional entre elementos
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: etiqueta.map((tag) {
                        return Container(
                          padding: EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: priceFontSize,
                              color: Colors.white,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
