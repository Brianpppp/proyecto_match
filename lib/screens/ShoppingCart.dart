import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'package:todolist_firebase/screens/home_screen.dart';

class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text('Error: Usuario no autenticado.'),
        ),
      );
    }

    return Scaffold(
      body: Column(
        children: [
          Header(),
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('usuarios').doc(user.email).snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;
                if (!userData.containsKey('carrito')) {
                  return Center(
                    child: Text('Añade algún elemento al carrito para que aparezca el contenido.'),
                  );
                }

                final Map<String, dynamic> carrito = userData['carrito'];
                if (carrito.isEmpty) {
                  return Center(
                    child: Text('El carrito está vacío.'),
                  );
                }

                double totalCompra = 0.0;
                return ListView.builder(
                  itemCount: carrito.length + 1,
                  itemBuilder: (context, index) {
                    if (index == carrito.length) {
                      return ListTile(
                        title: Text(
                          'Total de la compra:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text(
                          '€${totalCompra.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      );
                    }
                    final String docId = carrito.keys.elementAt(index);
                    final Map<String, dynamic> producto = carrito[docId];
                    final double precioUnitario = producto['precio'];
                    final int cantidad = producto['cantidad'];
                    final double precioTotalProducto = producto['precio_total'] ?? (precioUnitario * cantidad);
                    totalCompra += precioTotalProducto;

                    carrito[docId]['precio_total'] = precioTotalProducto;

                    return ListTile(
                      title: Text(producto['nombre']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Cantidad: $cantidad'),
                          Text('Precio unitario: €$precioUnitario'),
                          Text('Precio total: €${precioTotalProducto.toStringAsFixed(2)}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance.collection('usuarios').doc(user.email).update({
                            'carrito.$docId': FieldValue.delete(),
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: Usuario no autenticado.')),
                );
              } else {
                FirebaseFirestore.instance.collection('usuarios').doc(user.email).get().then((docSnapshot) {
                  final carrito = docSnapshot.data()?['carrito'];
                  if (carrito == null || (carrito as Map).isEmpty) {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              'El carrito está vacío.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18.0),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    double totalCompra = 0.0;
                    carrito.forEach((key, value) {
                      totalCompra += value['precio_total'];
                    });

                    int puntosGanados = (totalCompra * 10).toInt();

                    FirebaseFirestore.instance.collection('usuarios').doc(user.email).update({
                      'puntos': FieldValue.increment(puntosGanados),
                    });

                    // Guardar la compra en la colección "compras"
                    FirebaseFirestore.instance.collection('compras').add({
                      'emailUsuario': user.email,
                      'fecha': Timestamp.now(),
                      'productos': carrito,
                      'total': totalCompra,
                      'puntosGanados': puntosGanados,
                    });

                    FirebaseFirestore.instance.collection('usuarios').doc(user.email).update({
                      'carrito': FieldValue.delete(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Compra realizada con éxito. Ganaste $puntosGanados puntos.')),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                  }
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Finalizar Compra', style: TextStyle(fontSize: 18)),
            ),
          ),
          SizedBox(height: 20),
          Footer(),
        ],
      ),
    );
  }
}
