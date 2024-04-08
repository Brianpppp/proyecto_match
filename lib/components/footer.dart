import 'package:flutter/material.dart';

class Footer extends StatefulWidget {
  @override
  _FooterState createState() => _FooterState();
}

class _FooterState extends State<Footer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Aquí puedes agregar lógica para navegar a diferentes páginas
    switch (_selectedIndex) {
      case 0:
      // Navegar a la página de inicio
       Navigator.pushNamed(context, '/home_screen');
        break;
      case 1:
      // Navegar a la página de menú de comida rápida
       Navigator.pushNamed(context, '/menu_card');
        break;
      case 2:
      // Navegar a la página del carrito de compras
      Navigator.pushNamed(context, '/store_points');
        break;
      case 3:
      // Navegar a la página de perfil de usuario
       Navigator.pushNamed(context, '/user');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.grey[800],
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      iconSize: 40,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.home),
            alignment: Alignment.center,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Container(
            child: Icon(Icons.fastfood_sharp),
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
            child: Icon(Icons.person),
            alignment: Alignment.center,
          ),
          label: '',
        ),
      ],
    );
  }
}
