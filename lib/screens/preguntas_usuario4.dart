import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PreguntasUsuario4 extends StatefulWidget {
  PreguntasUsuario4();

  @override
  _PreguntasUsuario4State createState() => _PreguntasUsuario4State();
}

class _PreguntasUsuario4State extends State<PreguntasUsuario4>
    with TickerProviderStateMixin {
  List<int> _selectedIndexes = []; // Lista para almacenar los índices seleccionados
  List<String> opciones = [
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
    'Fortnite',
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
        _progressValue = 0.8 +
            (_controller.value *
                0.40); // Ajusta el valor del progreso entre 0.8 y 1
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

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedIndexes.contains(index)) {
        _selectedIndexes.remove(index);
      } else {
        if (_selectedIndexes.length < 5) {
          _selectedIndexes.add(index);
        }
      }
    });
  }

  bool _isSelected(int index) {
    return _selectedIndexes.contains(index);
  }

  bool _isButtonEnabled() {
    return _selectedIndexes.length == 5;
  }

  String _getButtonText() {
    if (_selectedIndexes.length == 0) {
      return 'Next 0/5';
    } else if (_selectedIndexes.length < 5) {
      return 'Next ${_selectedIndexes.length}/5';
    } else {
      return 'Finalizar';
    }
  }

  void _guardarRespuestasEnFirebase(bool requireExactlyFive, BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        List<String> etiquetasSeleccionadas = [];

        // Recorrer todas las opciones y obtener las etiquetas seleccionadas
        for (int index in _selectedIndexes) {
          String etiquetaSeleccionada = opciones[index];

          // Verificar si la etiqueta ya existe en Firestore
          final etiquetaDoc = await FirebaseFirestore.instance
              .collection('etiqueta4')
              .doc(etiquetaSeleccionada)
              .get();

          if (!etiquetaDoc.exists) {
            // La etiqueta no existe, así que la agregamos a Firestore
            await FirebaseFirestore.instance
                .collection('etiqueta4')
                .doc(etiquetaSeleccionada)
                .set({ 'nombre': etiquetaSeleccionada });
          }

          etiquetasSeleccionadas.add(etiquetaSeleccionada);
        }

        // Verificar si se seleccionaron todas las etiquetas
        if (requireExactlyFive ? etiquetasSeleccionadas.length == 5 : etiquetasSeleccionadas.every((etiqueta) => etiqueta.isNotEmpty)) {
          // Actualizar las etiquetas del usuario en Firestore
          await FirebaseFirestore.instance
              .collection('usuarios')
              .doc(user.email)
              .set({
            'etiqueta4': etiquetasSeleccionadas,
          }, SetOptions(merge: true));

          // Navegar a la siguiente pantalla (HomeScreen)
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          // Mostrar un diálogo si no se seleccionaron todas las etiquetas
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) { // Cambiado el nombre del contexto para evitar conflictos
              return AlertDialog(
                title: Text("Selección requerida"),
                content:
                Text("Por favor selecciona ${requireExactlyFive ? 'exactamente 5' : 'todas'} opciones."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // Usar el contexto del diálogo
                    },
                    child: Text("OK"),
                  ),
                ],
              );
            },
          );
        }
      }
    } catch (e) {
      print('Error al guardar las etiquetas: $e');
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
      body: Column(
        children: [
          SizedBox(height: 20), // Añade espacio adicional antes del título
          Center(
            child: Container(
              margin: EdgeInsets.only(
                  bottom: 40.0), // Margen inferior entre el título y las etiquetas
              child: Text(
                'Cual es tu rollo?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Expanded(
            child: Wrap(
              spacing: 0.0, // Elimina el espacio horizontal entre elementos
              runSpacing: 0.0, // Elimina el espacio vertical entre elementos
              children: List.generate(opciones.length, (index) {
                String opcion = opciones[index];
                return GestureDetector(
                  onTap: () {
                    _toggleSelection(index);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // Borde más circular
                    ),
                    color: _isSelected(index)
                        ? Color.fromRGBO(226, 169, 209, 1.0)
                        : Colors.white, // Cambia el color de fondo si está seleccionado

                    child: Padding(
                      padding: EdgeInsets.all(12.0), // Padding reducido
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(opcion),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              if (!_isButtonEnabled()) {
                _guardarRespuestasEnFirebase(true, context); // Pasar el contexto y requerir exactamente cinco opciones
              } else {
                _guardarRespuestasEnFirebase(false, context); // Pasar el contexto y no requerir exactamente cinco opciones
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                    20), // Puedes ajustar el valor según tus necesidades
              ),
              backgroundColor: _isButtonEnabled()
                  ? Color.fromRGBO(226, 169, 209, 1.0)
                  : Colors.grey, // Color de fondo del botón
            ),
            child: Text(
              _getButtonText(),
              style: TextStyle(
                  fontSize: 20, color: Colors.white), // Estilo de texto del botón
            ),
          ),
          SizedBox(height: 20), // Espacio adicional después del botón
        ],
      ),
    );
  }
}
