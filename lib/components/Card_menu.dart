import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Details.dart';
import 'footer.dart';


class CardMenu extends StatelessWidget {
  final String collection;

  CardMenu({required this.collection});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [

          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection(collection).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsPage(doc: doc),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 1.0, // El contenedor ocupa el 90% del ancho de la pantalla
                            height: MediaQuery.of(context).size.width * 0.5,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width * 0.25, // Ancho del contenedor de la imagen
                                      height: MediaQuery.of(context).size.width * 0.3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0), // Bordes redondeados en la parte superior derecha
                                          bottomRight: Radius.circular(20.0), // Bordes redondeados en la parte inferior derecha
                                        ),
                                        color: Colors.pinkAccent[100], // Color de fondo rosa claro
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20.0),
                                          bottomLeft: Radius.circular(20.0),
                                          topRight: Radius.circular(20.0), // Bordes redondeados en la parte superior derecha
                                          bottomRight: Radius.circular(20.0), // Bordes redondeados en la parte inferior derecha
                                        ),
                                        child: Image.network(
                                          doc['url'],
                                          fit: BoxFit.cover,
                                          width: MediaQuery.of(context).size.width * 0.25, // Ancho de la imagen
                                          height: MediaQuery.of(context).size.width * 0.3,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
          // Aquí está el Footer importado
          Footer(),
        ],
      ),
    );
  }
}
