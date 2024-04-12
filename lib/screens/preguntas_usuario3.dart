import 'package:flutter/material.dart';
import 'preguntas_usuario4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreguntasUsuario3 extends StatefulWidget {
  PreguntasUsuario3();

  @override
  _PreguntasUsuario3State createState() => _PreguntasUsuario3State();
}

class _PreguntasUsuario3State extends State<PreguntasUsuario3>
    with TickerProviderStateMixin {
  int _selectedIndex = -1;
  final List<String> opciones = [
    '¿Haces ejercicio?',
    'No es mi rollo',
    'Los findes, por socializar',
    'Siempre que puedo',
    'Muy de vez en cuando',
    '¿Tienes mascotas?',
    'Perro',
    'Gato',
    'Pájaro',
    'Peces',
    'No tengo, ¡pero me encantaría!',
    'No me gustan los animales',
    'Hámster',
    'No tengo mascotas',
    'Todo tipo de mascotas',
    'Otros',
    '¿Cómo te gusta recibir el amor?',
    'Pequeños detalles',
    'Regalos',
    'Contacto físico',
    'Palabras bonitas',
    'Tiempo de calidad',
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
                'Cuéntanos un poco sobre tus hábitos?',
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          // Mostrar preguntas estáticas
          Expanded(
            child: ListView.builder(
              itemCount: opciones.length,
              itemBuilder: (BuildContext context, int index) {
                String opcion = opciones[index];
                if (opcion.startsWith('¿')) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    child: Text(
                      opcion,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return GestureDetector(
                    onTap: () {
                      _seleccionarOpcion(index);
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
                            Text(
                              opcion,
                              textAlign: TextAlign.center,
                            ),
                            // No mostramos el icono de verificación cuando la etiqueta está seleccionada
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PreguntasUsuario4()),
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
