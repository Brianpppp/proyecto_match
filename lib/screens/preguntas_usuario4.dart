import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'preguntas_usuario3.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreguntasUsuario4 extends StatefulWidget {
  PreguntasUsuario4();

  @override
  _PreguntasUsuario4State createState() => _PreguntasUsuario4State();
}

class _PreguntasUsuario4State extends State<PreguntasUsuario4>
    with TickerProviderStateMixin {
  int _selectedIndex = -1;
  final List<String> opciones = [
    'Fiestas en casa',
    'Meditación',
    'Teatro',
    'Viajar',
    'Gimnasio',
    'Redes sociales',
    'Cine',
    'Deportes',
    'Cambio climático',
    'Arte',
    'Manga',
    'Fiestas',
    'Memes',
    'Mochileros',
    'Maquillaje',
    'Rock',
    'Autocine',
    'Festivales',
    'Reggaeton',
    'Fornite',
    'Cuidado de la piel',
    'Guitarrista',
    'Correr',
    'Zapatillas',
    'Hot yoga',
    'Explorar ',
    'Creatividad ',
    'Montaña ',
    'Playa ',
    'Spa ',
    'Jazz  ',
    'Fotografía',
    'Exposiciones ',
    'Flamenco ',
    'Voluntariado ',
    'Ecologismo ',
    ' Blogger ',
    'Vida nocturna ',
    'Picnic',
    'Disney',
  ];

  late AnimationController _controller;

  double _progressValue = 0.0;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
      setState(() {
        _progressValue = 0.40 + (_controller.value * 0.40); // Ajusta el valor del progreso entre 0.3 y 0.6
      });
    });
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _seleccionarOpcion(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.pink,
        ),
        title: LinearProgressIndicator(
          value: _progressValue,
          semanticsLabel: 'Linear progress indicator',
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.only(bottom: 20.0), // Margen inferior entre el título y las etiquetas
              child: Text(
                'Cual es tu rollo?',
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 0.0, // Elimina el espacio horizontal entre elementos
              runSpacing: 0.0, // Elimina el espacio vertical entre elementos
              children: opciones.map((opcion) {
                int index = opciones.indexOf(opcion);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index; // Actualiza el estado con el índice de la opción seleccionada
                    });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Borde más circular
                    ),
                    color: _selectedIndex == index ? Colors.green : Colors.white, // Cambia el color de fondo si está seleccionado

                    child: Padding(
                      padding: EdgeInsets.all(12.0), // Padding reducido
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(opcion),
                          // No mostramos el icono de verificación cuando la etiqueta está seleccionada
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              minimumSize: Size(double.infinity, 50),
            ),
            child: Text(
              'Next',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
