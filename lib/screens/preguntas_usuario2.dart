import 'package:flutter/material.dart';
import 'preguntas_usuario3.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PreguntasUsuario2 extends StatefulWidget {
  PreguntasUsuario2();

  @override
  _PreguntasUsuario2State createState() => _PreguntasUsuario2State();
}

class _PreguntasUsuario2State extends State<PreguntasUsuario2>
    with TickerProviderStateMixin {
  int _selectedIndex = -1;
  final List<String> opciones = [
    'Tomate',
    'Pepinillos',
    'Queso',
    'Bacon',
    'Huevo',
    'Lechuga',
    'Cebolla',
    'Salsa',
    'No lo tengo claro',
  ];

  // Lista de rutas de imágenes correspondientes a cada opción
  final List<String> imagenes = [
    'icono_tomate.png',
    'icono_pepino.png',
    'icono_queso.png',
    'icono_bacon.png',
    'icono_huevo.png',
    'icono_lechuga.png',
    'icono_cebolla.png',
    'icono_salsa.png',
    'icono_pensar.png',
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
        _progressValue = 0.10 + (_controller.value * 0.30); // Ajusta el valor del progreso entre 0.3 y 0.6
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

  bool _isButtonEnabled() {
    return _selectedIndex != -1;
  }

  void _guardarRespuestaEnFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Obtener la etiqueta seleccionada por el usuario
        String etiquetaSeleccionada = '';

        // Agregar la etiqueta seleccionada si existe
        if (_selectedIndex != -1) {
          etiquetaSeleccionada = opciones[_selectedIndex];
        }

        // Verificar si se seleccionó una etiqueta
        if (etiquetaSeleccionada.isNotEmpty) {
          // Actualizar las etiquetas del usuario en Firestore
          await FirebaseFirestore.instance.collection('usuarios').doc(user.email).set({
            'etiqueta2': etiquetaSeleccionada, // Guardar la etiqueta seleccionada en Firestore
          }, SetOptions(merge: true)); // Usar merge para mantener otros datos del usuario

          // Imprimir la etiqueta seleccionada en la consola para verificar
          print('Etiqueta seleccionada2: $etiquetaSeleccionada');

          // Navegar a la siguiente pantalla (PreguntasUsuario3 en este caso)
          Navigator.pushReplacement( // Reemplaza la pantalla actual en lugar de agregar una nueva
            context,
            MaterialPageRoute(builder: (context) => PreguntasUsuario3()),
          );
        } else {
          print('Error: No se seleccionó ninguna etiqueta');
        }
      }
    } catch (e) {
      print('Error al guardar la etiqueta: $e');
      // Manejar el error aquí
    }
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
          color: Color.fromRGBO(226, 169, 209, 1.0),
        ),
        title: LinearProgressIndicator(
          value: _progressValue,
          semanticsLabel: 'Linear progress indicator',
          backgroundColor: Colors.grey[300], // Color de fondo de la barra de progreso
          valueColor: AlwaysStoppedAnimation<Color>(
            Color.fromRGBO(226, 169, 209, 1.0), // Color de la barra de progreso
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10), // Añadir espacio entre el título y los cuadros de texto
            Center(
              child: Text(
                'Qué ingrediente no puede faltar en tu hamburguesa?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40), // Añadir más espacio entre el título y los cuadros de texto
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemCount: opciones.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      _seleccionarOpcion(index);
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: _selectedIndex == index
                          ? Color.fromRGBO(226, 169, 209, 1.0)
                          : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/${imagenes[index]}',
                            height: 50, // Ajusta la altura de la imagen según sea necesario
                          ),
                          Text(
                            opciones[index],
                            style: TextStyle(
                              fontSize: 16,
                              color: _selectedIndex == index
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20), // Añadir espacio entre los cuadros de texto y el botón
            Container(
              margin: EdgeInsets.only(bottom: 30), // Puedes ajustar el valor según tus necesidades
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedIndex != -1) {
                    _guardarRespuestaEnFirebase();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PreguntasUsuario3()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Selección requerida"),
                          content: Text("Por favor selecciona un ingrediente."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("OK"),
                            ),
                          ],
                        );
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  backgroundColor: _isButtonEnabled() ? Color.fromRGBO(226, 169, 209, 1.0) : Colors.grey,

                ),
                child: Text(
                  _selectedIndex != -1 ? 'Next' : 'Next',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
