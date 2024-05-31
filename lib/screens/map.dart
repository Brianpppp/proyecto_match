import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../components/footer.dart';
import '../components/header.dart';
import 'home_screen.dart'; // Importa la pantalla HomeScreen

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StorePage(),
    );
  }
}


class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  LatLng? _selectedLocation; // Variable para almacenar la ubicación seleccionada

  // Definimos las ubicaciones predefinidas de los restaurantes Goiko en Barcelona
  final List<LatLng> goikoLocations = [
    LatLng(41.3835, 2.1764),  // Goiko Diagonal
  ];

  // Posición por defecto en el centro de Barcelona
  final LatLng _defaultPosition = LatLng(41.3851, 2.1734);

  void _showReservationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Reserva completada"),
          content: Text("¡Tu reserva ha sido realizada con éxito!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: Text("Aceptar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Column(
        children: [
          Container(
            height: 60,  // Header height
            child: Header(),
          ),
          Expanded( // Usamos Expanded para que el contenido ocupe el espacio restante
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1),  // Fondo rosa para el contenido
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Restaurantes Match en Barcelona',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24, // Tamaño del texto aumentado
                        fontWeight: FontWeight.w900, // Mayor peso para resaltar más
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Mayor espacio debajo del texto
                  Container(
                    height: 550,  // Altura fija para el mapa
                    margin: EdgeInsets.symmetric(vertical: 8.0),  // Espaciado alrededor del mapa
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.withOpacity(0.4), // Sombra rosa
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FlutterMap(
                        options: MapOptions(
                          center: _defaultPosition,
                          zoom: 14.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                          MarkerLayer(
                            markers: [
                              // Marcadores para las ubicaciones predefinidas de Goiko
                              ...goikoLocations.map((location) => Marker(
                                width: 80.0,
                                height: 80.0,
                                point: location,
                                builder: (ctx) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // Alternar entre seleccionar y deseleccionar la ubicación
                                      if (_selectedLocation == location) {
                                        _selectedLocation = null;
                                      } else {
                                        _selectedLocation = location;
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 60, // Ancho del contenedor del marcador
                                    height: 60, // Alto del contenedor del marcador
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: _selectedLocation == location ? Colors.red : Colors.pinkAccent,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.pink.withOpacity(0.4), // Color rosa con opacidad
                                          blurRadius: 5,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.asset(
                                        'assets/match3.png',  // Ruta al archivo PNG
                                        width: 50,  // Ajusta el tamaño de la imagen
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )).toList(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Container(
                      width: 200, // Ancho fijo del contenedor del botón
                      child: ElevatedButton(
                        onPressed: _selectedLocation != null ? () {
                          // Acción al presionar el botón de reserva
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen()),
                          );
                          _showReservationDialog(context); // Mostrar el diálogo de reserva completada
                        } : null,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Espaciado interno del botón
                          child: Text(
                            'Reservar',
                            style: TextStyle(
                              fontSize: 20, // Tamaño del texto del botón aumentado
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
