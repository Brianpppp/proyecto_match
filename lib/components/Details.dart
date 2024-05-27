import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'header.dart';
import 'footer.dart';

class DetailsPage extends StatelessWidget {
  final DocumentSnapshot doc;

  DetailsPage({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 169, 209, 1),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Image.network(
                        doc['url'],
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.width * 0.5,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Colors.black54],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          doc['apodo'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 1),
                                blurRadius: 4.0,
                                color: Colors.black.withOpacity(0.75),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 169, 209, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          spreadRadius: 5,
                          blurRadius: 7,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ingredientes",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          doc['descripcion'],
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        SizedBox(height: 16),
                        Divider(
                          color: Colors.black54,
                          thickness: 1,
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Descripción",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          doc['texto'],
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Footer(), // Agregar el footer como bottomNavigationBar
    );
  }
}
