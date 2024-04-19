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
  List<Bebida> bebidas = [];
  List<Snack> snacks = [];
  List<Postre> postres = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchHamburguesas();
    _fetchBebidas();
    _fetchSnacks();
    _fetchPostres();
  }

  void _fetchHamburguesas() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('hamburguesas').get();
      List<Hamburguesa> list = querySnapshot.docs.map((doc) => Hamburguesa.fromSnapshot(doc)).toList();

      setState(() {
        hamburguesas = list;
      });
    } catch (e) {
      print('Error fetching hamburguesas: $e');
    }
  }

  void _fetchBebidas() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('bebida').get();
      List<Bebida> list = querySnapshot.docs.map((doc) => Bebida.fromSnapshot(doc)).toList();

      setState(() {
        bebidas = list;
      });
    } catch (e) {
      print('Error fetching bebidas: $e');
    }
  }

  void _fetchSnacks() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('snack').get();
      List<Snack> list = querySnapshot.docs.map((doc) => Snack.fromSnapshot(doc)).toList();

      setState(() {
        snacks = list;
      });
    } catch (e) {
      print('Error fetching snacks: $e');
    }
  }

  void _fetchPostres() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('postre').get();
      List<Postre> list = querySnapshot.docs.map((doc) => Postre.fromSnapshot(doc)).toList();

      setState(() {
        postres = list;
      });
    } catch (e) {
      print('Error fetching postres: $e');
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
              bebida: bebidas,
              snacks: snacks,
              postres: postres,
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
      ],
    );
  }
}

class TabSection extends StatelessWidget {
  final List<Hamburguesa> hamburguesas;
  final List<Bebida> bebida;
  final List<Snack> snacks;
  final List<Postre> postres;

  const TabSection({Key? key, required this.hamburguesas, required this.bebida, required this.snacks, required this.postres}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Column(
        children: [
          TabBar(
            labelColor: Colors.black,
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
              children: [
                ImageSection(hamburguesas: hamburguesas),
                ImageSection(bebida: bebida),
                ImageSection(snacks: snacks),
                ImageSection(postres: postres),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ImageSection extends StatelessWidget {
  final List<Hamburguesa> hamburguesas;
  final List<Bebida> bebida;
  final List<Snack> snacks;
  final List<Postre> postres;

  const ImageSection({Key? key, this.hamburguesas = const [], this.bebida = const [], this.snacks = const [], this.postres = const []}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      itemCount: hamburguesas.length + bebida.length + snacks.length + postres.length,
      itemBuilder: (context, index) {
        // Lógica para construir las tarjetas de cada tipo de comida
        if (index < hamburguesas.length) {
          return _buildHamburguesaCard(context, index);
        } else if (index < hamburguesas.length + bebida.length) {
          int bebidaIndex = index - hamburguesas.length;
          return _buildBebidaCard(context, bebidaIndex);
        } else if (index < hamburguesas.length + bebida.length + snacks.length) {
          int snackIndex = index - hamburguesas.length - bebida.length;
          return _buildSnackCard(context, snackIndex);
        } else {
          int postreIndex = index - hamburguesas.length - bebida.length - snacks.length;
          return _buildPostreCard(context, postreIndex);
        }
      },
    );
  }

  // Construir tarjeta de hamburguesa
  Widget _buildHamburguesaCard(BuildContext context, int index) {
    return Container(
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
    );
  }

  // Construir tarjeta de bebida
  Widget _buildBebidaCard(BuildContext context, int index) {
    return Container(
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
                      bebida[index].nombre,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      'Precio: \$${bebida[index].precio}',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  bebida[index].url,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  bebida[index].descripcion,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construir tarjeta de snack
  Widget _buildSnackCard(BuildContext context, int index) {
    return Container(
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
                      snacks[index].nombre,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      'Precio: \$${snacks[index].precio}',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  snacks[index].url,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  snacks[index].descripcion,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Construir tarjeta de postre
  Widget _buildPostreCard(BuildContext context, int index) {
    return Container(
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
                      postres[index].nombre,
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.06),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      'Precio: \$${postres[index].precio}',
                      style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                    ),
                  ],
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Align(
                alignment: Alignment.center,
                child: Image.network(
                  postres[index].url,
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: MediaQuery.of(context).size.height * 0.3,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  postres[index].descripcion,
                  style: TextStyle(fontSize: MediaQuery.of(context).size.width * 0.04),
                ),
              ),
            ],
          ),
        ),
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
        precio = snapshot['precio'].toDouble(),
        descripcion = snapshot['descripcion'],
        url = snapshot['url'];
}

class Bebida {
  final String nombre;
  final double precio;
  final String descripcion;
  final String url;

  Bebida({required this.nombre, required this.precio, required this.descripcion, required this.url});

  Bebida.fromSnapshot(DocumentSnapshot snapshot):
        nombre = snapshot['nombre'],
        precio = snapshot['precio'].toDouble(),
        descripcion = snapshot['descripcion'],
        url = snapshot['url'];
}

class Snack {
  final String nombre;
  final double precio;
  final String descripcion;
  final String url;

  Snack({required this.nombre, required this.precio, required this.descripcion, required this.url});

  Snack.fromSnapshot(DocumentSnapshot snapshot):
        nombre = snapshot['nombre'],
        precio = snapshot['precio'].toDouble(),
        descripcion = snapshot['descripcion'],
        url = snapshot['url'];
}

class Postre {
  final String nombre;
  final double precio;
  final String descripcion;
  final String url;

  Postre({required this.nombre, required this.precio, required this.descripcion, required this.url});

  Postre.fromSnapshot(DocumentSnapshot snapshot):
        nombre = snapshot['nombre'],
        precio = snapshot['precio'].toDouble(),
        descripcion = snapshot['descripcion'],
        url = snapshot['url'];
}
