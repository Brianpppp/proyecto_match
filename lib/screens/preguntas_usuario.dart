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
    '🍔\nTernera',
    '🍗\nPollo',
    '🥗\nEnsalada Vegana',
    '🐷\nCerdo',
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
        _progressValue = 0.01 + (_controller.value * 0.10); // Ajusta el valor del progreso entre 0.01 y 0.10
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
        padding: EdgeInsets.all(8.0), // Agregar un margen uniforme alrededor de los elementos
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20), // Añadir más espacio entre el título y los cuadros de texto
            Center(
              child: Text(
                'Que tipo de hamburguesa te gusta?',
                style: TextStyle(
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20), // Añadir más espacio entre el título y los cuadros de texto
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
                      color: _selectedIndex == index ? Colors.green : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            opciones[index],
                            style: TextStyle(
                              fontSize: 26, // Cambia el tamaño de la letra aquí
                              color: _selectedIndex == index ? Colors.white : Colors.black,
                            ),
                            textAlign: TextAlign.center, // Alinea el texto al centro
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
                    borderRadius: BorderRadius.circular(20), // Puedes ajustar el valor según tus necesidades
                  ),
                  backgroundColor: _isButtonEnabled() ? Colors.pink : Colors.grey,
                ),
                child: Text(
                  _selectedIndex != -1 ? 'Next' : 'Next',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            //UserInfo(email: widget.email), // Agregar UserInfo aquí
          ],
        ),
      ),
    );
  }
}
