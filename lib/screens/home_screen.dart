import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/footer.dart';
import '../components/header.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  List<Hamburguesa> hamburguesas = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchHamburguesas();
  }

  void _fetchHamburguesas() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('hamburguesas').get();
      List<Hamburguesa> list = querySnapshot.docs.map((doc) => Hamburguesa.fromSnapshot(doc)).toList();

      setState(() {
        hamburguesas = list;
      });
    } catch (e) {
      // Manejar errores al obtener hamburguesas
      print('Error fetching hamburguesas: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage() {
    setState(() {
      _currentPageIndex = (_currentPageIndex + 1) % hamburguesas.length;
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 169, 209, 1.0),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(),
          PhraseAndTexts(),
          Expanded(
            flex: 1,
            child: ImageSection(
              hamburguesas: hamburguesas,
              pageController: _pageController,
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          Buttons(onXPressed: _changePage),
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
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.05,
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          color: Color.fromRGBO(255, 169, 209, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Food', style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold)),
              Text('Drinks', style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold)),
              Text('Snacks', style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold)),
              Text('Desserts', style: TextStyle(color: Colors.black, fontSize: MediaQuery.of(context).size.width * 0.04, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageSection extends StatelessWidget {
  final List<Hamburguesa> hamburguesas;
  final PageController pageController;

  const ImageSection({Key? key, required this.hamburguesas, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 169, 209, 1.0),
      child: PageView.builder(
        controller: pageController,
        itemCount: hamburguesas.length,
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<int>(index),
              margin: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.03,
                horizontal: MediaQuery.of(context).size.width * 0.03,
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
                  color: Colors.white, // Fondo blanco
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hamburguesas[index].nombre,
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                            Text(
                              'Precio: \$${hamburguesas[index].precio}',
                              style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Align(
                        alignment: Alignment.center,
                        child: Image.network(
                          hamburguesas[index].url,
                          width: MediaQuery.of(context).size.width * 0.6,
                          height: MediaQuery.of(context).size.height * 0.3,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                        child: Text(
                          hamburguesas[index].descripcion,
                          style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  final VoidCallback onXPressed;

  const Buttons({Key? key, required this.onXPressed}) : super(key: key);

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
                decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle,),
                child: IconButton(
                  iconSize: buttonSize * 0.7,
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: onXPressed,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
              Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle,),
                child: IconButton(
                  iconSize: buttonSize * 0.7,
                  icon: Icon(Icons.favorite, color: Colors.white),
                  onPressed: () {
                    // Acción a realizar al presionar el botón del "Corazón"
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class Hamburguesa {
  final String nombre;
  final double precio;
  final String descripcion;
  final String url;

  Hamburguesa({required this.nombre, required this.precio, required this.descripcion, required this.url});

  Hamburguesa.fromSnapshot(DocumentSnapshot snapshot):
        nombre = snapshot['nombre'],
        precio = snapshot['precio'],
        descripcion = snapshot['descripcion'],
        url = snapshot['url'];
}