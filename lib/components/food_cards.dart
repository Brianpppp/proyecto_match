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
      margin: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        color: Colors.red, // Color de fondo rojo
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
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      apodo,
                      style: TextStyle(fontSize: nameFontSize),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: verticalPadding / 2),
                    Text(
                      nombre,
                      style: TextStyle(fontSize: nameFontSize),
                    ),
                    SizedBox(height: verticalPadding / 2),
                    Align(
                      alignment: Alignment.center,
                      child: Image.network(
                        url,
                        width: cardWidth * 0.7,
                        height: cardHeight * 0.4,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: verticalPadding / 2),
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
                              borderRadius: BorderRadius.circular(10.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
