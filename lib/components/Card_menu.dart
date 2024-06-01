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
  late List<double> prices;
  late List<String> names;
  final Map<String, dynamic> purchaseDetails = {};

  final Map<String, int> cart = {};

  @override
  void initState() {
    super.initState();
    counters = List<int>.filled(0, 0, growable: true);
    prices = List<double>.empty(growable: true);
    names = List<String>.empty(growable: true);
    _fetchData();
  }

  void _fetchData() async {
    final snapshot = await FirebaseFirestore.instance.collection(widget.collection).get();
    setState(() {
      counters = List<int>.filled(snapshot.docs.length, 0, growable: true);
      prices = snapshot.docs.map<double>((doc) => (doc['precio'] ?? 0.0).toDouble()).toList();
      names = snapshot.docs.map<String>((doc) => (doc['apodo'] ?? '')).toList();
    });
  }

  Future<void> _addToCart(String docId, int counter) async {
    setState(() {
      if (counter > 0) {
        // Verificar si el elemento ya está en el carrito
        if (cart.containsKey(docId)) {
          // Si el elemento ya está en el carrito, actualizar la cantidad existente
          cart[docId] = cart[docId]! + counter; // Sumar la cantidad nueva a la cantidad existente
        } else {
          // Si el elemento no está en el carrito, agregarlo como un nuevo elemento
          cart[docId] = counter;
        }
        // Calcular el precio total de este producto y guardarlo en el mapa de detalles de compra
        final index = cart.keys.toList().indexOf(docId);
        final totalPrice = prices[index] * counter;
        purchaseDetails[docId] = {
          'nombre': names[index],
          'cantidad': counter,
          'precio': prices[index],
          'precio_total': totalPrice, // Agregar el precio total del producto
        };
      } else {
        // Si la cantidad es 0, eliminar el elemento del carrito y de los detalles de compra
        cart.remove(docId);
        purchaseDetails.remove(docId);
      }
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
        // Calcular el precio total de la compra sumando los precios totales de todos los productos en el carrito
        double totalPurchasePrice = 0.0;
        cart.forEach((docId, quantity) {
          final index = cart.keys.toList().indexOf(docId);
          final totalPrice = prices[index] * quantity;
          totalPurchasePrice += totalPrice;
        });

        // Mapa para almacenar los detalles de compra actualizados con el precio total
        final Map<String, dynamic> purchaseDetailsWithTotalPrice = {};
        cart.forEach((docId, quantity) {
          final productDetails = purchaseDetails[docId];
          final totalPrice = productDetails['precio_total'];
          purchaseDetailsWithTotalPrice[docId] = {
            ...productDetails,
            'precio_total': totalPrice,
          };
        });

        // Registrar la compra en la colección 'compras'
        await FirebaseFirestore.instance.collection('compras').doc().set({
          'userEmail': userEmail,
          'productos': purchaseDetailsWithTotalPrice,
          'totalPrecio': totalPurchasePrice, // Agregar el precio total de la compra
          'timestamp': FieldValue.serverTimestamp(),
        });

        print('Compra registrada correctamente para $userEmail con los siguientes detalles:');
        purchaseDetailsWithTotalPrice.forEach((docId, productDetails) {
          print('ID del producto: $docId, Detalles: $productDetails');
        });

        // Ahora actualizamos el documento del usuario con la información del carrito al hacer checkout
        await userDoc.set({
          'carrito': purchaseDetails,
        }, SetOptions(merge: true));

        // Eliminamos el carrito local después de agregarlo a la base de datos
        cart.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Compra realizada con éxito.')),
        );
      } catch (e) {
        print('Error al registrar la compra: $e');
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
                      final int counter = counters[index];
                      final double price = prices.isEmpty ? 0.0 : prices[index];
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
                                        SizedBox(height: 8.0),
                                        Text(
                                          doc['descripcion'],
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
                                              _addToCart(doc.id, counters[index]);
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
                                            if (counters[index] > 0) {
                                              setState(() {
                                                counters[index]--;
                                                _addToCart(doc.id, counters[index]);
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
      bottomNavigationBar: Footer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _checkout,
        child: Icon(Icons.shopping_cart),
      ),
    );
  }
}
