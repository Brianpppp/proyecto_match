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
  List<int> _selectedIndexes = []; // Lista para almacenar los índices seleccionados
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
        _progressValue = 0.8 + (_controller.value * 0.40); // Ajusta el valor del progreso entre 0.8 y 1
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
              children: opciones.asMap().entries.map((entry) {
                int index = entry.key;
                String opcion = entry.value;
                return GestureDetector(
                  onTap: () {
                    _toggleSelection(index);
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0), // Borde más circular
                    ),
                    color: _isSelected(index) ? Colors.green : Colors.white, // Cambia el color de fondo si está seleccionado

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

          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (!_isButtonEnabled()) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Selección requerida"),
                      content: Text("Por favor selecciona exactamente 5 opciones."),
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
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Puedes ajustar el valor según tus necesidades
              ),
              backgroundColor: _isButtonEnabled() ? Colors.pink : Colors.grey, // Color de fondo del botón
            ),
            child: Text(
              _getButtonText(),
              style: TextStyle(fontSize: 20, color: Colors.white), // Estilo de texto del botón
            ),
          ),
          SizedBox(height: 20), // Espacio adicional después del botón

        ],
      ),
    );
  }
}
