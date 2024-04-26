import 'package:flutter/material.dart';
import '../components/footer.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromRGBO(255, 169, 209, 1),
                Colors.white,
              ], // Cambié el orden de los colores
              stops: [0.5, 1.0],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Capa semitransparente negra
                ),
              ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: menuButton(
                            title: 'Hamburguesas',
                            icon: Icons.restaurant,
                            onTap: () {
                              // Navegar a la página de hamburguesas
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: menuButton(
                            title: 'Bebidas',
                            icon: Icons.local_cafe,
                            onTap: () {
                              // Navegar a la página de bebidas
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: menuButton(
                            title: 'Snacks',
                            icon: Icons.lunch_dining,
                            onTap: () {
                              // Navegar a la página de snacks
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: menuButton(
                            title: 'Postres',
                            icon: Icons.cake,
                            onTap: () {
                              // Navegar a la página de postres
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: menuButton(
                            title: 'Cócteles',
                            icon: Icons.local_bar,
                            onTap: () {
                              // Navegar a la página de cócteles
                            },
                          ),
                        ),
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

  Widget menuButton(
      {required String title,
        required IconData icon,
        required VoidCallback onTap}) {
    return MaterialButton(
      onPressed: onTap,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30.0,
            color: Colors.black,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}