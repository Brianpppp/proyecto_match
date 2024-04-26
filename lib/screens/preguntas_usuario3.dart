import 'package:flutter/material.dart';
import 'preguntas_usuario4.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreguntasUsuario3 extends StatefulWidget {
  PreguntasUsuario3();

  @override
  _PreguntasUsuario3State createState() => _PreguntasUsuario3State();
}

class _PreguntasUsuario3State extends State<PreguntasUsuario3>
    with TickerProviderStateMixin {
  List<int> _selectedIndexes = [-1, -1, -1, -1];
  final List<List<String>> opciones = [
    [
      'No es mi rollo',
      'Los findes, por socializar',
      'Siempre que puedo',
      'Muy de vez en cuando'
    ],
    [
      'Cada día',
      'A menudo',
      'A veces',
      'Vivo en el gimnasio',
      'De vez en cuando',
      'Nunca'
    ],
    ['Perro', 'Gato', 'Pájaro', 'Peces', 'No tengo, ¡pero me encantaría!', 'No me gustan los animales', 'Hámster', 'Todo tipo de mascotas', 'Otros'],
    [
      'Pequeños detalles',
      'Regalos',
      'Contacto físico',
      'Palabras bonitas',
      'Tiempo de calidad'
    ]
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
        _progressValue = 0.30 + (_controller.value * 0.40);
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

  void _seleccionarOpcion(int listaIndex, int opcionIndex) {
    setState(() {
      _selectedIndexes[listaIndex] = opcionIndex;
    });
  }

  bool _isButtonEnabled() {
    return _selectedIndexes.where((index) => index != -1).length == 4;
  }

  void _guardarRespuestasEnFirebase() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> etiquetasSeleccionadas = [];

        // Recorrer todas las listas de opciones y obtener las etiquetas seleccionadas
        for (int i = 0; i < _selectedIndexes.length; i++) {
          // Obtener la etiqueta seleccionada para la lista actual
          int selectedIndex = _selectedIndexes[i];
          String etiquetaSeleccionada = selectedIndex != -1 ? opciones[i][selectedIndex] : '';
          etiquetasSeleccionadas.add(etiquetaSeleccionada);
        }

        // Verificar si se seleccionaron todas las etiquetas
        if (etiquetasSeleccionadas.every((etiqueta) => etiqueta.isNotEmpty)) {
          // Actualizar las etiquetas del usuario en Firestore
          await FirebaseFirestore.instance.collection('usuarios').doc(user.email).set({
            'etiquetas': etiquetasSeleccionadas, // Guardar las etiquetas seleccionadas en Firestore
          }, SetOptions(merge: true)); // Usar merge para mantener otros datos del usuario

          // Imprimir las etiquetas seleccionadas en la consola para verificar
          print('Etiquetas seleccionadas: $etiquetasSeleccionadas');

          // Navegar a la siguiente pantalla (PreguntasUsuario4 en este caso)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PreguntasUsuario4()),
          );
        } else {
          print('Error: No se seleccionaron todas las etiquetas');
        }
      }
    } catch (e) {
      print('Error al guardar las etiquetas: $e');
      // Manejar el error aquí
    }
  }


  @override
  Widget build(BuildContext context) {
    List<String> titulos = [
      '¿Con qué frecuencia sales de fiesta?',
      '¿Haces ejercicio?',
      '¿Tienes mascotas?',
      '¿Cómo te gusta recibir el amor?'
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Color.fromRGBO(226, 169, 209, 1.0), // Usando el mismo color
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
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10), // Espacio adicional al inicio
            Text(
              'Cuéntanos un poco sobre tus hábitos?',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 40), // Espacio adicional después del título
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(opciones.length, (index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            titulos[index],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 0.0,
                          runSpacing: 0.0,
                          children: opciones[index].map((opcion) {
                            return GestureDetector(
                              onTap: () {
                                _seleccionarOpcion(index, opciones[index].indexOf(opcion));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                color: _selectedIndexes[index] == opciones[index].indexOf(opcion)
                                    ? Color.fromRGBO(226, 169, 209, 1.0)
                                    : Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text(
                                    opcion,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20), // Espacio adicional al final
            SizedBox(
              height: 20, // Añadir un espacio entre el botón y el borde inferior de la pantalla
            ),
            ElevatedButton(
              onPressed: _isButtonEnabled()
                  ? () {
                _guardarRespuestasEnFirebase();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PreguntasUsuario4()),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: _isButtonEnabled() ? Color.fromRGBO(226, 169, 209, 1.0) : Colors.grey,
              ),
              child: Text(
                _selectedIndexes.contains(-1)
                    ? 'Next ${_selectedIndexes.where((index) => index != -1).length}/4'
                    : 'Next',
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 20), // Espacio adicional después del botón
          ],
        ),
      ),
    );
  }
}
