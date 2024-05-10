import 'package:flutter/material.dart';
import '../components/Card_menu.dart';
import '../components/Menu_Botton.dart';
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
              ],
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
                  color: Colors.black.withOpacity(0.5),
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
                          child: MenuButton(
                            title: 'Hamburguesas',
                            image: 'hamburguesaMenu.jpg',
                            onTap: () {
                              navigateToCards(context, 'hamburguesas');
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: MenuButton(
                            title: 'Bebidas',
                            image: 'bebidas.jpg',
                            onTap: () {
                              navigateToCards(context, 'bebida');
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: MenuButton(
                            title: 'Snakcs',
                            image: 'nachos.jpg',
                            onTap: () {
                              navigateToCards(context, 'snack');
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 100.0,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: MenuButton(
                            title: 'Desserts',
                            image: 'postr.jpg',
                            onTap: () {
                              navigateToCards(context, 'postre');
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

  void navigateToCards(BuildContext context, String collection) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CardMenu(collection: collection),
      ),
    );
  }
}
