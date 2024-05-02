import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todolist_firebase/screens/home_screen.dart';
import 'package:todolist_firebase/screens/menu_card.dart';
import 'package:todolist_firebase/screens/personal_info.dart';
import 'package:todolist_firebase/screens/store_points.dart';
import 'package:todolist_firebase/screens/user.dart';
import 'firebase_options.dart';
import 'screens/login_registro_screen.dart'; // Ajusta la ruta de importación

void main() async {
  // Código de inicialización de la aplicación
  WidgetsFlutterBinding.ensureInitialized();
  // Código de inicialización de Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

  );
  // Ejecuta la aplicación
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Esta línea oculta el banner de "Debug"
      title: 'Flutter Authentication',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: AuthScreen(), // Utiliza AuthScreen como la pantalla principalkk
      routes: {
        '/home_screen': (context)=> HomeScreen(),
        '/menu': (context) => MenuPage(),
        '/store_points': (context) => StorePage(),
        '/user': (context) => UserPage(),
        '/personal_info':(context)=> info(),
      },
    );
  }
}

 /*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App',
      home: UserPage(),
    );
  }
}*/


/*class ImageSection extends StatelessWidget {
  final List<Map<String, dynamic>> foodList;
  final PageController pageController;
  final String etiquetaSeleccionada;

  const ImageSection({
    Key? key,
    required this.foodList,
    required this.pageController,
    required this.etiquetaSeleccionada,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> filteredFoodList = [];
    final List<Map<String, dynamic>> otherFoodList = [];

    // Separar los alimentos que coinciden con la etiqueta seleccionada de los que no coinciden
    for (final food in foodList) {
      if (food['etiquetaSeleccionada'] == etiquetaSeleccionada) {
        filteredFoodList.add(food);
      } else {
        otherFoodList.add(food);
      }
    }

    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.horizontal,
      itemCount: filteredFoodList.length + otherFoodList.length,
      itemBuilder: (context, index) {
        if (index < filteredFoodList.length) {
          // Mostrar alimentos que coinciden con la etiqueta seleccionada
          return FoodCard(
            nombre: filteredFoodList[index]['nombre'],
            precio: filteredFoodList[index]['precio'].toDouble(),
            descripcion: filteredFoodList[index]['descripcion'],
            url: filteredFoodList[index]['url'],
            etiquetaSeleccionada: filteredFoodList[index]['etiquetaSeleccionada'],
          );
        } else {
          // Mostrar otros alimentos
          final otherIndex = index - filteredFoodList.length;
          return FoodCard(
            nombre: otherFoodList[otherIndex]['nombre'],
            precio: otherFoodList[otherIndex]['precio'].toDouble(),
            descripcion: otherFoodList[otherIndex]['descripcion'],
            url: otherFoodList[otherIndex]['url'],
            etiquetaSeleccionada: otherFoodList[otherIndex]['etiquetaSeleccionada'],
          );
        }
      },
    );
  }
}
*/
