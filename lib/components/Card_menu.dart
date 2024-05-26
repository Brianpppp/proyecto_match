import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Details.dart';
import 'footer.dart';

class CardMenu extends StatefulWidget {
  final String collection;

  CardMenu({required this.collection});

  @override
  _CardMenuState createState() => _CardMenuState();
}

class _CardMenuState extends State<CardMenu> {
  late List<int> counters;

  @override
  void initState() {
    super.initState();
    counters = List<int>.filled(0, 0, growable: true);
    _fetchCounters();
  }

  void _fetchCounters() async {
    final snapshot = await FirebaseFirestore.instance.collection(widget.collection).get();
    setState(() {
      counters = List<int>.filled(snapshot.docs.length, 0, growable: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                          padding: const EdgeInsets.all(15.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.width * 0.4, // Reducir la altura de la caja general
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
                                      margin: EdgeInsets.all(10.0),
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      height: MediaQuery.of(context).size.width * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20.0),
                                        color: Color.fromRGBO(255, 169, 209, 1),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20.0),
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
                                            SizedBox(height: 4.0), // Reducir espacio entre los textos
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
                                    Container(
                                      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Color.fromRGBO(255, 169, 209, 1),
                                        ),
                                        padding: EdgeInsets.all(4.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.add, color: Colors.red), // Iconos rojos
                                              onPressed: () {
                                                setState(() {
                                                  counters[index]++;
                                                  _updateCounter(doc.id, counters[index]);
                                                });
                                              },
                                            ),
                                            Text(
                                              counters[index].toString(), // Contador
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white, // Texto rojo
                                              ),
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.remove, color: Colors.red), // Iconos rojos
                                              onPressed: () {
                                                if (counters[index] > 0) {
                                                  setState(() {
                                                    counters[index]--;
                                                    _updateCounter(doc.id, counters[index]);
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
                          ),
                        ),
                      );
                    },
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

  void _updateCounter(String docId, int counter) {
    FirebaseFirestore.instance.collection(widget.collection).doc(docId).update({'counter': counter});
  }
}
