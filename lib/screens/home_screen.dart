import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../components/header.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> imagePaths = [
    'assets/hamburguesa.jpg',
    'assets/hamburguesa2.jpg',
    'assets/hamburguesa3.jpg',
    'assets/hamburguesa4.jpg',
    'assets/hamburguesa5.jpg',
  ];

  late PageController _pageController;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _changePage() {
    setState(() {
      _currentPageIndex = (_currentPageIndex + 1) % imagePaths.length;
      _pageController.animateToPage(
        _currentPageIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
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
                  imagePaths: imagePaths,
                  pageController: _pageController,
                  screenWidth: constraints.maxWidth,
                  screenHeight: constraints.maxHeight,
                ),
              ),
              SizedBox(height: 5), // Agregamos un espacio entre la sección de imágenes y los botones
              Buttons(onXPressed: _changePage),
              SizedBox(height: 20), // Espacio entre los botones y el footer
              Footer(),
            ],
          ),
        );
      },
    );
  }
}

class PhraseAndTexts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.03),
          color: Color.fromRGBO(255, 169, 209, 1.0),
          child: Text(
            'Ready to find love tonight?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 50, // Altura del contenedor
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1), // Margen horizontal del 10% de la pantalla a cada lado
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Bordes redondeados
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.03), // Espacio vertical del 3% de la altura de la pantalla
        Container(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05),
          color: Color.fromRGBO(255, 169, 209, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Food', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Drinks', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Snacks', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Desserts', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ],
    );
  }
}

class ImageSection extends StatelessWidget {
  final List<String> imagePaths;
  final PageController pageController;
  final double screenWidth;
  final double screenHeight;

  const ImageSection({Key? key, required this.imagePaths, required this.pageController, required this.screenWidth, required this.screenHeight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 169, 209, 1.0),
      child: PageView.builder(
        controller: pageController,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: Container(
              key: ValueKey<int>(index),
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: screenWidth * 0.15),
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
                child: Image.asset(
                  imagePaths[index],
                  width: screenWidth,
                  height: screenHeight * 0.4,
                  fit: BoxFit.cover,
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
        SizedBox(height: 1), // Espacio entre la sección de imágenes y los botones
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
              SizedBox(width: MediaQuery.of(context).size.width * 0.05), // Espacio ajustado al 5% del ancho de la pantalla
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


