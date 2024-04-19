import 'package:flutter/material.dart';
import 'preguntas_usuario2.dart';
import 'login_registro_screen.dart';

class PreguntasUsuario extends StatefulWidget {
  final String email;

  PreguntasUsuario({required this.email});

  @override
  _PreguntasUsuarioState createState() => _PreguntasUsuarioState();
}

class _PreguntasUsuarioState extends State<PreguntasUsuario>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = -1;
  final List<String> opciones = [
    'Ternera',
    'Pollo',
    'Ensalada Vegana',
    'Cerdo',
  ];

  // Lista de rutas de imágenes correspondientes a cada opción
  final List<String> imagenes = [
    'icono_hamburguesa.png',
    'icono_pollo.png',
    'icono_ensaladavegana.png',
    'icono_cerdo.png',
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
        _progressValue = 0.01 + (_controller.value * 0.10);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: LinearProgressIndicator(
          value: _progressValue,
          semanticsLabel: 'Linear progress indicator',
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 10),
            Center(
              child: Text(
                'Que tipo de hamburguesa te gusta?',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
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
                          ? Color.fromRGBO(226, 50, 42, 1)
                          : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            imagenes[index], // Utiliza la ruta de imagen correspondiente
                            height: 50, // Ajusta la altura de la imagen según sea necesario
                          ),
                          Text(
                            opciones[index],
                            style: TextStyle(
                              fontSize: 26,
                              color: _selectedIndex == index ? Colors.white : Colors.black,
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
            SizedBox(height: 20),
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedIndex != -1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreguntasUsuario2()),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Selección requerida"),
                          content: Text("Por favor selecciona un tipo de hamburguesa."),
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
                  backgroundColor: _isButtonEnabled() ? Colors.pink : Colors.grey,
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
