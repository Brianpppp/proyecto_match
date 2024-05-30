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
    final double nameFontSize = screenWidth * 0.05;
    final double priceFontSize = screenWidth * 0.045; // Aumenta el tamaño de la fuente del precio

    return Container(
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        color: Colors.white,
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
              padding: EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        apodo,
                        style: TextStyle(
                          fontSize: nameFontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '€${precio.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: priceFontSize,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0), // Reducido el espacio vertical
                  Text(
                    nombre,
                    style: TextStyle(fontSize: nameFontSize),
                  ),
                  SizedBox(height: 10.0), // Reducido el espacio vertical
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      url,
                      width: cardWidth * 1.2,
                      height: cardHeight * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 15.0), // Reducido el espacio vertical
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
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontSize: 16.0, // Cambia este valor para reducir el tamaño de la letra
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
