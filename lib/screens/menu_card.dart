import 'package:flutter/material.dart';
import '../components/Card_menu.dart';
import '../components/Menu_Botton.dart';
import '../components/footer.dart';
import '../components/header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/firestore_funciones.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromRGBO(255, 169, 209, 1), // Rosa
                Color.fromRGBO(255, 169, 209, 1), // Rosa (repetido)
                Colors.white, // Blanco
              ],
              stops: [0.0, 0.30, 0.06], // Distribución de colores: 0% rosa, 5% rosa, 6% blanco
            ),
          ),
          child: Stack(
            children: [
              Header(),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildMenuItem(
                        context,
                        'Hamburguesas',
                        'la_rubia.png',
                            () => navigateToCards(context, 'hamburguesas'),
                      ),
                      SizedBox(height: 30), // Añade espacio vertical entre las cajas

                      buildMenuItem(
                        context,
                        'Bebidas',
                        'coca_cola_zero.png',
                            () => navigateToCards(context, 'bebida'),
                      ),
                      SizedBox(height: 30), // Añade espacio vertical entre las cajas

                      buildMenuItem(
                        context,
                        'Snacks',
                        'nachos_con_queso.png',
                            () => navigateToCards(context, 'snack'),
                      ),
                      SizedBox(height: 30), // Añade espacio vertical entre las cajas

                      buildMenuItem(
                        context,
                        'Desserts',
                        'la_union_del_loto.png',
                            () => navigateToCards(context, 'postre'),
                      ),
                      SizedBox(height: 30), // Añade espacio vertical entre las cajas

                      buildMenuItem(
                        context,
                        'Cocteles',
                        'en_la_cama.png',
                            () => navigateToCards(context, 'coctel'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, String title, String image, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 110.0,

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0), // Reduce el espacio entre las cajas
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(left: 90.0, right: 40.0), // Ajusta el margen para hacer la caja más corta
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.white, // Fondo blanco para la caja principal
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0), // Ajusta el padding para reducir la longitud de la caja de texto
                  child: Center(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 50,
                top: 10,
                child: Container(
                  width: 90.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(255, 212, 232, 1.0), // Fondo rosa
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void navigateToCards(BuildContext context, String collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardMenu(collection: collection),
      ),
    );
  }
}
