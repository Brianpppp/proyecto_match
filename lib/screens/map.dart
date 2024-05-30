import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../components/footer.dart';
import '../components/header.dart';

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
  // Definimos las ubicaciones predefinidas de los restaurantes Goiko en Barcelona
  final List<LatLng> goikoLocations = [
    LatLng(41.3911, 2.1608),  // Goiko Passeig de Gràcia
    LatLng(41.3835, 2.1764),  // Goiko Diagonal
    LatLng(41.3931, 2.1651),  // Goiko Rambla Catalunya
  ];

  // Posición por defecto en el centro de Barcelona
  final LatLng _defaultPosition = LatLng(41.3851, 2.1734);

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
                        fontSize: 32, // Tamaño del texto aumentado
                        fontWeight: FontWeight.w900, // Mayor peso para resaltar más
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Mayor espacio debajo del texto
                  Container(
                    height: 400,  // Altura fija para el mapa
                    margin: EdgeInsets.symmetric(vertical: 16.0),  // Espaciado alrededor del mapa
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
                                    showDialog(
                                      context: ctx,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text('Restaurante Match'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text('Ubicación: (${location.latitude}, ${location.longitude})'),
                                              SizedBox(height: 10),
                                              Text('Detalles del Restaurante:'),
                                              Text('Este es uno de los restaurantes más populares de Barcelona, conocido por su excelente servicio y deliciosa comida.'),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text('Cerrar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.pinkAccent,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
