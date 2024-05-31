import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/firestore_funciones.dart';
import '../components/food_cards.dart'; // Importar el componente FoodCard
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
  String selectedLabel = '';
  List<String> filtrar = [];

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

    User? user = await _getCurrentUser();
    if (user != null) {
      selectedLabel = await _getUserSelectedLabel(user);
      filtrar = (await _getUserFiltrar(user)).cast<String>();
    }
    setState(() {});
  }
  Future<List<dynamic>> _getUserFiltrar(User user) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('usuarios').doc(user.email).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        // Asumiendo que 'filtrar' es un array en Firestore
        return data['etiqueta4'] ?? [];
      }
    } catch (e) {
      print('Error getting user filtrar array: $e');
    }
    return [];
  }

  Future<String> _getUserSelectedLabel(User user) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection('usuarios').doc(user.email).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        return data['etiqueta1'] ?? '';
      }
    } catch (e) {
      print('Error getting user selected label: $e');
    }
    return '';
  }
  Future<void> _addToFavorites(Map<String, dynamic> foodItem) async {
    User? user = await _getCurrentUser();
    if (user != null) {
      DocumentReference userRef = FirebaseFirestore.instance.collection('usuarios').doc(user.email);

      await userRef.update({
        'favoritos': FieldValue.arrayUnion([foodItem]),
      }).catchError((error) {
        print('Error adding to favorites: $error');
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage(int itemCount, int currentPageIndex) {
    // Verifica si estamos en la última página
    if (currentPageIndex == itemCount - 1) {
      // Si estamos en la última página, volvemos a la primera página
      _pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      // Si no estamos en la última página, avanzamos a la siguiente página
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
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
              selectedLabel: selectedLabel,
              filtrar:filtrar
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Buttons(
            nextPage: () {
              int currentPageIndex = _pageController.page?.round() ?? 0;
              int itemCount = _pageController.positions.isNotEmpty
                  ? _pageController.positions.first.viewportDimension != null
                  ? _pageController.positions.first.maxScrollExtent ~/ _pageController.positions.first.viewportDimension + 1
                  : 0
                  : 0;
              _nextPage(itemCount, currentPageIndex);
            },
            onFavorite: () {
              int currentPageIndex = _pageController.page?.round() ?? 0;
              // Get the list of items based on the current tab index
              List<Map<String, dynamic>> currentList;
              switch (_tabController.index) {
                case 0:
                  currentList = _filterAndSort(hamburguesas, filtrar);
                  break;
                case 1:
                  currentList = _filterAndSort(bebidas, filtrar);
                  break;
                case 2:
                  currentList = _filterAndSort(snacks, filtrar);
                  break;
                case 3:
                  currentList = _filterAndSort(postres, filtrar);
                  break;
                default:
                  currentList = [];
              }
              if (currentPageIndex < currentList.length) {
                Map<String, dynamic> currentItem = currentList[currentPageIndex];
                _addToFavorites(currentItem);
                int itemCount = currentList.length;
                _nextPage(itemCount, currentPageIndex);
              }
            },
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
  final VoidCallback onFavorite;
  const Buttons({Key? key, required this.nextPage,required this.onFavorite}) : super(key: key);

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
                margin: EdgeInsets.only(right: MediaQuery.of(context).size.width * 0.30),
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle,),
                child: IconButton(
                  iconSize: buttonSize * 0.6,
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
                  iconSize: buttonSize * 0.6,
                  icon: Icon(Icons.favorite, color: Colors.white),
                  onPressed: onFavorite,  // Función del botón de "Favorito" sin asignar
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
  final String selectedLabel;
  final List<String> filtrar;



  const TabSection({
    Key? key,
    required this.hamburguesas,
    required this.bebidas,
    required this.snacks,
    required this.postres,
    required this.tabController,
    required this.pageController,
    required this.selectedLabel,
    required this.filtrar
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    List<Map<String, dynamic>> filteredHamburguesas = _filterAndSort(
        hamburguesas.where((hamburguesa) => hamburguesa['etiquetaSeleccionada'] == selectedLabel).toList(),
        filtrar
    );
    List<Map<String, dynamic>> filteredHamburguesas2 = _filterAndSort(
        hamburguesas.where((hamburguesa) => hamburguesa['etiquetaSeleccionada'] != selectedLabel).toList(),
        filtrar
    );

    List<Map<String, dynamic>> filteredBebidas = _filterAndSort(bebidas, filtrar);
   // List<Map<String, dynamic>> remainingBebidas = bebidas.where((bebida) => bebida['etiqueta'] != filtrar).toList();
    List<Map<String, dynamic>> filteredSnacks = _filterAndSort(snacks, filtrar);
   // List<Map<String, dynamic>> remainingSnacks = snacks.where((snack) => snack['etiqueta'] != filtrar).toList();
    List<Map<String, dynamic>> filteredPostres = _filterAndSort(postres, filtrar);
   // List<Map<String, dynamic>> remainingPostres = postres.where((postre) => postre['etiqueta'] != filtrar).toList();
    return Column(
      children: [
        TabBar(
          controller: tabController,
          labelColor: Colors.black,
          indicatorColor: Colors.red,
          tabs: [
            Tab(
              child: Text(
                'Food',
                style: TextStyle(
                  fontSize: 17.0, // Modifica el tamaño de la letra aquí
                  fontWeight: FontWeight.bold, // Aquí aplicas la propiedad fontWeight
                ),
              ),
            ),
            Tab(
              child: Text(
                'Drinks',
                style: TextStyle(
                  fontSize: 17.0, // Modifica el tamaño de la letra aquí
                  fontWeight: FontWeight.bold, // Aquí aplicas la propiedad fontWeight
                ),
              ),
            ),
            Tab(
              child: Text(
                'Snacks',
                style: TextStyle(
                  fontSize: 17.0, // Modifica el tamaño de la letra aquí
                  fontWeight: FontWeight.bold, // Aquí aplicas la propiedad fontWeight
                ),
              ),
            ),
            Tab(
              child: Text(
                'Desserts',
                style: TextStyle(
                  fontSize: 17.0, // Modifica el tamaño de la letra aquí
                  fontWeight: FontWeight.bold, // Aquí aplicas la propiedad fontWeight
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              ImageSection(foodList:  filteredHamburguesas + filteredHamburguesas2, pageController: pageController),
              ImageSection(foodList: filteredBebidas , pageController: pageController),
              ImageSection(foodList:  filteredSnacks  , pageController: pageController),
              ImageSection(foodList: filteredPostres  , pageController: pageController),
            ],
          ),
        ),
      ],
    );
  }
}
List<Map<String, dynamic>> _filterAndSort(List<Map<String, dynamic>> items, List<String> selectedTags) {
  // Filtrar los elementos según las etiquetas seleccionadas por el usuario
  List<Map<String, dynamic>> filteredItems = items.where((item) => item['etiqueta'].any((tag) => selectedTags.contains(tag))).toList();

  // Ordenar los elementos según el número de etiquetas coincidentes
  filteredItems.sort((a, b) {
    int scoreA = a['etiqueta'].where((tag) => selectedTags.contains(tag)).length;
    int scoreB = b['etiqueta'].where((tag) => selectedTags.contains(tag)).length;
    return scoreB.compareTo(scoreA); // Ordenar de mayor a menor
  });

  // Agregar los elementos que no tienen etiquetas coincidentes
  List<Map<String, dynamic>> unrelatedItems = items.where((item) => !item['etiqueta'].any((tag) => selectedTags.contains(tag))).toList();
  filteredItems.addAll(unrelatedItems);

  return filteredItems;
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
        // Convertir la lista dinámica a una lista de cadenas
        List<String> etiquetas = List<String>.from(foodList[index]['etiqueta']);

        return FoodCard(
          nombre: foodList[index]['nombre'],
          precio: foodList[index]['precio'].toDouble(),
          descripcion: foodList[index]['descripcion'],
          url: foodList[index]['url'],
          etiquetaSeleccionada: foodList[index]['etiquetaSeleccionada'],
          apodo: foodList[index]['apodo'],
          etiqueta: etiquetas, // Pasar la lista de etiquetas
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
          var maxPuntos = 225; // Aquí puedes establecer el máximo de puntos posible
          var progress = puntos / maxPuntos;

          return Container(
            margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.12),
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo blanco
              borderRadius: BorderRadius.circular(20), // Bordes redondeados del contenedor
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
                        fontSize: MediaQuery.of(context).size.width * 0.05,
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
                            strokeWidth: MediaQuery.of(context).size.width * 0.016  , // Grosor del círculo
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Cambia el color a rojo
                            backgroundColor:Color.fromRGBO(255, 169, 209, 1),
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


