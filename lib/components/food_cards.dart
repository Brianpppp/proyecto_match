import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String nombre;
  final double precio;
  final String descripcion;
  final String url;
  final String etiquetaSeleccionada;

  const FoodCard({
    Key? key,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.url,
    required this.etiquetaSeleccionada,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double cardWidth = screenWidth * 0.4;
    final double cardHeight = screenHeight * 0.35;
    final double horizontalPadding = screenWidth * 0.12;
    final double verticalPadding = screenHeight * 0.01;
    final double nameFontSize = screenWidth * 0.06;
    final double priceFontSize = screenWidth * 0.04;
    final double descriptionFontSize = screenWidth * 0.04;

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
                      nombre,
                      style: TextStyle(fontSize: nameFontSize),
                    ),
                    SizedBox(height: verticalPadding / 2),
                    Text(
                      'Precio: \$${precio.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: priceFontSize),
                    ),
                  ],
                ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  descripcion,
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
              ),
              SizedBox(height: verticalPadding / 2),
              Center(
                child: Text(
                  etiquetaSeleccionada,
                  style: TextStyle(
                    fontSize: priceFontSize,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: verticalPadding),
            ],
          ),
        ),
      ),
    );
  }
}
