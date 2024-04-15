import 'package:flutter/material.dart';
import 'preguntas_usuario3.dart';

class PreguntasUsuario2 extends StatefulWidget {
  PreguntasUsuario2();

  @override
  _PreguntasUsuario2State createState() => _PreguntasUsuario2State();
}

class _PreguntasUsuario2State extends State<PreguntasUsuario2>
    with TickerProviderStateMixin {
  int _selectedIndex = -1;
  final List<String> opciones = [
    '🍅 \nTOMATE',
    '🥒 \nPEPINILLOS',
    '🧀 \nQUESO',
    '🥓 \nBACON',
    '🍳 \nHUEVO',
    '🥬 \nLECHUGA',
    '🧅 \nCEBOLLA',
    '🥫 \nSALSA',
    '🤔 \nNO LO TENGO CLARO',
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
        _progressValue = 0.10 + (_controller.value * 0.40); // Ajusta el valor del progreso entre 0.3 y 0.6
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20), // Añadir espacio entre el título y los cuadros de texto
            Center(
              child: Text(
                'Qué ingrediente no puede faltar en tu hamburguesa?',
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
                      color: _selectedIndex == index ? Colors.green : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            opciones[index],
                            style: TextStyle(
                              fontSize: 20,
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
            SizedBox(height: 20), // Añadir espacio entre los cuadros de texto y el botón
            Container(
              margin: EdgeInsets.only(bottom: 30), // Puedes ajustar el valor según tus necesidades
              child: ElevatedButton(
                onPressed: () {
                  if (_selectedIndex != -1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PreguntasUsuario3()),
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
          ],
        ),
      ),
    );
  }
}
