import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          backgroundColor: Color.fromRGBO(255, 169, 209, 1),
          icon: Container(
            child: Icon(Icons.home),
            alignment: Alignment.center, // Center the icon within the container
          ),
          label: '', // Empty label
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.person),
            alignment: Alignment.center,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.shopping_cart),
            alignment: Alignment.center,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.menu),
            alignment: Alignment.center,
          ),
          label: '',
        ),
      ],
    );
  }
}