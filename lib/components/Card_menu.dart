import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'footer.dart';
import 'header.dart';

class CardMenu extends StatefulWidget {
  final String collection;

  CardMenu({required this.collection});

  @override
  _CardMenuState createState() => _CardMenuState();
}

class _CardMenuState extends State<CardMenu> {
  late List<int> counters;
  final Map<String, dynamic> productDetails = {};
  final Map<String, dynamic> purchaseDetails = {};
  final Map<String, int> cart = {};

  @override
  void initState() {
    super.initState();
    counters = List<int>.filled(0, 0, growable: true);
    _fetchData();
  }

  void _fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection(widget.collection).get();
    setState(() {
      counters = List<int>.filled(snapshot.docs.length, 0, growable: true);
      for (var doc in snapshot.docs) {
        productDetails[doc.id] = {
          'nombre': doc['apodo'],
          'precio': (doc['precio'] ?? 0.0).toDouble(),
          'url': doc['url'],
          'descripcion': doc['descripcion'],
        };
      }
    });
  }

  void _addToCart(String docId, int counter, int index) {
    setState(() {
      if (counter > 0) {
        cart[docId] = counter;

        final product = productDetails[docId];
        final totalPrice = product['precio'] * counter;

        purchaseDetails[docId] = {
          'nombre': product['nombre'],
          'cantidad': counter,
          'precio': product['precio'],
          'precio_total': totalPrice,
        };
      } else {
        cart.remove(docId);
        purchaseDetails.remove(docId);
      }

      counters[index] = counter;
    });
  }

  Future<void> _checkout() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, inicia sesión para realizar la compra.')),
      );
      return;
    }

    final userEmail = user.email;
    if (userEmail != null) {
      final userDoc = FirebaseFirestore.instance.collection('usuarios').doc(userEmail);

      try {
        await userDoc.set({
          'carrito': purchaseDetails,
        }, SetOptions(merge: true));

        setState(() {
          cart.clear();
          purchaseDetails.clear();
          counters = List<int>.filled(counters.length, 0);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Carrito actualizado con éxito.')),
        );
      } catch (e) {
        print('Error al actualizar el carrito: $e');
      }
    } else {
      print('El usuario no tiene un correo electrónico.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Header(),
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
                      final String docId = doc.id;
                      final int counter = counters[index];
                      final product = productDetails[docId];
                      final double price = product['precio'];
                      final double totalPrice = counter * price;

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
                                  width: MediaQuery.of(context).size.width * 0.28,
                                  height: MediaQuery.of(context).size.width * 0.28,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Color.fromRGBO(255, 212, 232, 1.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50.0),
                                    child: Image.network(
                                      product['url'],
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
                                          product['nombre'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          product['descripcion'],
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(
                                            fontSize: 12.0,
                                          ),
                                        ),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Precio unitario: €${price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
                                          ),
                                        ),
                                        SizedBox(height: 2.0),
                                        Text(
                                          'Total: €${totalPrice.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            color: Colors.black,
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
                                    padding: EdgeInsets.all(2.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          iconSize: 20.0,
                                          icon: Icon(Icons.add, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              counters[index]++;
                                              _addToCart(docId, counters[index], index);
                                            });
                                          },
                                        ),
                                        Text(
                                          counters[index].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          iconSize: 20.0,
                                          icon: Icon(Icons.remove, color: Colors.red),
                                          onPressed: () {
                                            setState(() {
                                              if (counters[index] > 0) {
                                                counters[index]--;
                                                _addToCart(docId, counters[index], index);
                                              }
                                            });
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
      bottomNavigationBar: Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkout,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
