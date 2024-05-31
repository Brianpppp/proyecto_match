import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/footer.dart';
import '../components/header.dart';
import 'home_screen.dart';

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
  LatLng? _selectedLocation;
  final List<LatLng> goikoLocations = [
    LatLng(41.3835, 2.1764), // Goiko Diagonal
  ];
  final LatLng _defaultPosition = LatLng(41.3851, 2.1734);
  bool reservaExitosa = false;
  bool ubicacionSeleccionada = false;

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
    ).then((_) {
      setState(() {
        // Actualizar el estado para mostrar el mensaje de reserva exitosa
        reservaExitosa = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Column(
        children: [
          Container(
            height: 60,
            child: Header(),
          ),
          Expanded(
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1),
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Restaurantes Match en Barcelona',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        ubicacionSeleccionada = true;
                      });
                    },
                    child: Container(
                      height: 450,
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.pink.withOpacity(0.4),
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
                              urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                              subdomains: ['a', 'b', 'c'],
                            ),
                            MarkerLayer(
                              markers: [
                                ...goikoLocations.map((location) => Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: location,
                                  builder: (ctx) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedLocation = location;
                                        ubicacionSeleccionada = true;
                                      });
                                    },
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: _selectedLocation ==
                                              location
                                              ? Colors.red
                                              : Colors.pinkAccent,
                                          width: 2,
                                        ),
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                            Colors.pink.withOpacity(0.4),
                                            blurRadius: 5,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        child: Image.asset(
                                          'assets/match3.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('usuarios')
                        .doc(FirebaseAuth.instance.currentUser!.email)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }

                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      var reserva = data['reserva'] ?? false;

                      return Center(
                        child: Container(
                          width: 250,
                          child: ElevatedButton(
                            onPressed: ubicacionSeleccionada
                                ? () {
                              if (reserva) {
                                // Cancelar reserva
                                FirebaseFirestore.instance
                                    .collection('usuarios')
                                    .doc(FirebaseAuth.instance.currentUser!.email)
                                    .update({'reserva': false}).then((_) {
                                  setState(() {
                                    reservaExitosa = false;
                                  });
                                });
                              } else {
                                // Realizar reserva
                                FirebaseFirestore.instance
                                    .collection('usuarios')
                                    .doc(FirebaseAuth.instance.currentUser!.email)
                                    .update({'reserva': true}).then((_) {
                                  setState(() {
                                    reservaExitosa = true;
                                  });
                                  _showReservationDialog(context);
                                });
                              }
                            }
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 20.0),
                              child: Text(
                                reserva ? 'Cancelar Reserva' : 'Reservar',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
