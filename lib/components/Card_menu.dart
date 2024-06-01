import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'footer.dart';
import 'header.dart'; // Asegúrate de importar correctamente tu encabezado

class CardMenu extends StatefulWidget {
  final String collection;

  CardMenu({required this.collection});

  @override
  _CardMenuState createState() => _CardMenuState();
}

class _CardMenuState extends State<CardMenu> {
  late List<int> counters;
  late List<double> prices;

  @override
  void initState() {
    super.initState();
    counters = List<int>.filled(0, 0, growable: true);
    prices = List<double>.empty(growable: true); // Inicializar la lista de precios
    _fetchData();
  }

  void _fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection(widget.collection).get();
    setState(() {
      counters = List<int>.filled(snapshot.docs.length, 0, growable: true);
      // Obtener los precios de cada documento y almacenarlos en la lista de precios
      prices = snapshot.docs.map<double>((doc) => (doc['precio'] ?? 0.0).toDouble()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(), // Aquí importamos tu encabezado
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(widget.collection).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final int counter = counters[index];
                      final double price = prices.isEmpty ? 0.0 : prices[index]; // Obtener el precio del documento como punto flotante
                      final double totalPrice = counter * price; // Calcular el precio total

                      return Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width * 0.28, // Reducir el ancho del contenedor de la imagen
                                  height: MediaQuery.of(context).size.width * 0.28, // Reducir el alto del contenedor de la imagen
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Color.fromRGBO(255, 212, 232, 1.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.network(
                                      doc['url'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          doc['apodo'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(height: 8.0), // Aumentar el espacio entre los elementos
                                        Text(
                                          doc['descripcion'],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        SizedBox(height: 8.0), // Aumentar el espacio entre los elementos
                                        Text(
                                          'Precio unitario: €${price.toStringAsFixed(2)}', // Mostrar dos decimales
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black, // Color del precio
                                          ),
                                        ),
                                        SizedBox(height: 2.0), // Aumentar el espacio entre los elementos
                                        Text(
                                          'Total: €${totalPrice.toStringAsFixed(2)}', // Mostrar dos decimales
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black, // Color del precio total
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      color: Color.fromRGBO(255, 212, 232, 1.0),
                                    ),
                                    padding: EdgeInsets.all(2.0), // Reducir el espacio interior del contenedor
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 20.0, // Reducir el tamaño del ícono
                                          icon: Icon(Icons.add, color: Colors.red), // Iconos rojos
                                          onPressed: () {
                                            setState(() {
                                              counters[index]++;
                                              _updateCounter(doc.id, counters[index]); // Actualizar el contador
                                            });
                                          },
                                        ),
                                        Text(
                                          counters[index].toString(), // Contador
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0, // Reducir el tamaño de la fuente
                                            color: Colors.white, // Texto rojo
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 20.0, // Reducir el tamaño del ícono
                                          icon: Icon(Icons.remove, color: Colors.red), // Iconos rojos
                                          onPressed: () {
                                            if (counters[index] > 0) {
                                              setState(() {
                                                counters[index]--;
                                                _updateCounter(doc.id, counters[index]); // Actualizar el contador
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      // Aquí está el Footer importado
      bottomNavigationBar: Footer(),
    );
  }

  void _updateCounter(String docId, int counter) {
    FirebaseFirestore.instance.collection(widget.collection).doc(docId).update({
      'counter': counter,
    });
  }
}
