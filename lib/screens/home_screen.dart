import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/firestore_funciones.dart';
import '../components/food_cards.dart';
import '../components/footer.dart';
import '../components/header.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  List<Map<String, dynamic>> hamburguesas = [];
  List<Map<String, dynamic>> bebidas = [];
  List<Map<String, dynamic>> snacks = [];
  List<Map<String, dynamic>> postres = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _pageController = PageController();
    _fetchData();
  }

  void _fetchData() async {
    hamburguesas = await FirestoreService.getCollection('hamburguesas');
    bebidas = await FirestoreService.getCollection('bebida');
    snacks = await FirestoreService.getCollection('snack');
    postres = await FirestoreService.getCollection('postre');
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Color.fromRGBO(255, 169, 209, 1);

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(),
          PhraseAndTexts(),
          Expanded(
            flex: 1,
            child: TabSection(
              hamburguesas: hamburguesas,
              bebidas: bebidas,
              snacks: snacks,
              postres: postres,
              tabController: _tabController,
              pageController: _pageController,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Buttons(
            nextPage: _nextPage,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Footer(),
        ],
      ),
    );
  }
}

class PhraseAndTexts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.01),
          color: Color.fromRGBO(255, 169, 209, 1.0),
          child: Text(
            'Ready to find love tonight?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.06,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        FutureBuilder<User?>(
          future: _getCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (userSnapshot.hasError) {
              return Text('Error: ${userSnapshot.error}');
            } else {
              if (userSnapshot.hasData) {
                return _buildUsernameWidget(context, userSnapshot.data!);
              } else {
                return Text(
                  'Nombre de Usuario no disponible',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                );
              }
            }
          },
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
      ],
    );
  }
}

class Buttons extends StatelessWidget {
  final VoidCallback nextPage;

  const Buttons({Key? key, required this.nextPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double buttonSize = MediaQuery.of(context).size.width <= 600 ? MediaQuery.of(context).size.width * 0.12 : 50.0;

    return Column(
      children: [
        SizedBox(height: 1),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.09),
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle,),
                child: IconButton(
                  iconSize: buttonSize * 0.7,
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: nextPage, // Movemos la página al hacer clic en el botón "X"
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle,),
                child: IconButton(
                  iconSize: buttonSize * 0.7,
                  icon: Icon(Icons.favorite, color: Colors.white),
                  onPressed: (){}, // Función del botón de "Favorito" sin asignar
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TabSection extends StatelessWidget {
  final List<Map<String, dynamic>> hamburguesas;
  final List<Map<String, dynamic>> bebidas;
  final List<Map<String, dynamic>> snacks;
  final List<Map<String, dynamic>> postres;
  final TabController tabController;
  final PageController pageController;

  const TabSection({Key? key, required this.hamburguesas, required this.bebidas, required this.snacks, required this.postres, required this.tabController, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.red,
          tabs: [
            Tab(text: 'Food'),
            Tab(text: 'Drinks'),
            Tab(text: 'Snacks'),
            Tab(text: 'Desserts'),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ImageSection(foodList: hamburguesas, pageController: pageController),
              ImageSection(foodList: bebidas, pageController: pageController),
              ImageSection(foodList: snacks, pageController: pageController),
              ImageSection(foodList: postres, pageController: pageController),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageSection extends StatelessWidget {
  final List<Map<String, dynamic>> foodList;
  final PageController pageController;

  const ImageSection({Key? key, required this.foodList, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.horizontal,
      itemCount: foodList.length,
      itemBuilder: (context, index) {
        return FoodCard(
          nombre: foodList[index]['nombre'],
          precio: foodList[index]['precio'].toDouble(),
          descripcion: foodList[index]['descripcion'],
          url: foodList[index]['url'],
          etiquetaSeleccionada: foodList[index]['etiquetaSeleccionada'],
        );
      },
    );
  }
}

Future<User?> _getCurrentUser() async {
  return FirebaseAuth.instance.currentUser;
}

Widget _buildUsernameWidget(BuildContext context, User user) {
  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance.collection('usuarios').doc(user.email).get(),
    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else {
        if (snapshot.hasData && snapshot.data!.exists) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          var username = userData['nombre'];
          var puntos = userData['puntos'] ?? 0;
          var maxPuntos = 100; // Aquí puedes establecer el máximo de puntos posible
          var progress = puntos / maxPuntos;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo blanco
              borderRadius: BorderRadius.circular(10), // Bordes redondeados del contenedor
            ),
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      username ?? 'Nombre de Usuario no disponible',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.1),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.09, // Tamaño del gráfico circular (alto)
                          width: MediaQuery.of(context).size.width * 0.09, // Tamaño del gráfico circular (ancho)
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: MediaQuery.of(context).size.width * 0.012, // Grosor del círculo
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Cambia el color a rojo
                            backgroundColor: Colors.grey,
                          ),
                        ),
                        Text(
                          '$puntos',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'Nombre de Usuario no disponible',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          );
        }
      }
    },
  );
}

