import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../components/header.dart';

class HomeScreen extends StatelessWidget {
  final List<String> imagePaths = [
    'assets/hamburguesa.jpg',
    'assets/hamburguesa2.jpg',
    'assets/hamburguesa3.jpg',
    'assets/hamburguesa4.jpg',
    'assets/hamburguesa5.jpg',
  ];
  final PageController _pageController = PageController();

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
            child: ImageSection(imagePaths: imagePaths, pageController: _pageController),
          ),
          Buttons(),
        ],
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

class PhraseAndTexts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color.fromRGBO(255, 169, 209, 1.0),
          child: Text(
            'Ready to find love tonight?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          color: Color.fromRGBO(255, 169, 209, 1.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Food', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('Drinks', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('Snacks', style: TextStyle(color: Colors.white, fontSize: 16)),
              Text('Desserts', style: TextStyle(color: Colors.white, fontSize: 16)),
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

  const ImageSection({Key? key, required this.imagePaths, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(255, 169, 209, 1.0),
      height: 150,
      child: PageView.builder(
        controller: pageController,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8, // Ancho del 80% de la pantalla
              height: 150,
              child: Image.asset(
                imagePaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.purple[200],
            ),
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () {
                // Acción a realizar al presionar el botón "X"
              },
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink[300],
            ),
            child: IconButton(
              icon: Icon(Icons.favorite, color: Colors.white),
              onPressed: () {
                // Acción a realizar al presionar el botón del "Corazón"
              },
            ),
          ),
        ],
      ),
    );
  }
}
