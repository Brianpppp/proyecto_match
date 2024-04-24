import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  final String nombre;
  final double precio;
  final String descripcion;
  final String url;

  const FoodCard({
    Key? key,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final double cardWidth = screenWidth * 0.84;
    final double cardHeight = screenHeight * 0.35;
    final double horizontalPadding = screenWidth * 0.05;
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
                    SizedBox(height: verticalPadding),
                    Text(
                      'Precio: \$${precio.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: priceFontSize),
                    ),
                  ],
                ),
              ),
              SizedBox(height: verticalPadding),
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  url,
                  width: cardWidth * 0.7,
                  height: cardHeight * 0.4,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: verticalPadding),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Text(
                  descripcion,
                  style: TextStyle(fontSize: descriptionFontSize),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
