import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/header.dart';
import '../components/footer.dart';

class Info extends StatefulWidget {
  @override
  _InfoState createState() => _InfoState();
}

class _InfoState extends State<Info> {
  late Future<DocumentSnapshot> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  Future<DocumentSnapshot> _getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return await FirebaseFirestore.instance.collection('usuarios').doc(user.email).get();
    } else {
      throw Exception("No user logged in");
    }
  }

  Future<void> _eliminarFavorito(dynamic favorito) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userEmail = user.email!;
      await FirebaseFirestore.instance.collection('usuarios').doc(userEmail).update({
        'favoritos': FieldValue.arrayRemove([favorito])
      });
      setState(() {
        _userDataFuture = _getUserData();
      });
    }
  }

  void _showEditProfileModal(BuildContext context) async {
    TextEditingController _usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar perfil'),
          content: TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Nuevo nombre de usuario'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                String newUsername = _usernameController.text.trim();
                if (newUsername.isNotEmpty) {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance.collection('usuarios').doc(user.email).update({'nombre': newUsername});
                    Navigator.pop(context); // Cerrar el modal
                    setState(() {
                      _userDataFuture = _getUserData(); // Recargar la página
                    });
                  }
                }
              },
              child: Text('Guardar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar el modal
              },
              child: Text('Cancelar'),
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
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  color: Color.fromRGBO(255, 169, 209, 1),
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(color: Colors.white),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Header(),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 60,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    FutureBuilder<DocumentSnapshot>(
                      future: _userDataFuture,
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }
                        if (snapshot.hasData && snapshot.data!.exists) {
                          var userData = snapshot.data!.data() as Map<String, dynamic>;
                          var username = userData['nombre'];
                          var etiqueta1 = userData['etiqueta1'];
                          var etiqueta2 = userData['etiqueta2'];
                          var etiqueta4 = userData['etiqueta4'] as List<dynamic>;
                          var puntos = userData['puntos'] ?? 0;
                          var favoritos = userData['favoritos'] as List<dynamic>? ?? [];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Información personal',
                                style: TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.all(16.0),
                                margin: EdgeInsets.symmetric(horizontal: 26.0, vertical: 8.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      spreadRadius: 1,
                                      blurRadius: 1,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage('assets/match3.png'),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Text(
                                        username ?? 'nombre de usuario no disponible',
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showEditProfileModal(context);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                        minimumSize: Size(0, 40),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(30),
                                        ),
                                        backgroundColor: Color.fromRGBO(255, 169, 209, 1),
                                      ),
                                      child: Text(
                                        'Editar perfil',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(12, 12, 20, 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Puntos',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Por cada 1€ de compra en nuestro restaurante optendras 10 puntos en nuestra tienda.',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Container(
                                                    width: 50,
                                                    height: 50,
                                                    child: CircularProgressIndicator(
                                                      value: puntos / 225,
                                                      strokeWidth: 8,
                                                      backgroundColor: Colors.grey.withOpacity(0.3),
                                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Text(
                                                      '$puntos',
                                                      style: TextStyle(
                                                        fontSize: MediaQuery.of(context).size.width * 0.04,
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Preferencias de $username',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: [
                                  _buildEtiqueta(etiqueta1),
                                  _buildEtiqueta(etiqueta2),
                                ],
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Gustos de $username',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 10),
                              Wrap(
                                alignment: WrapAlignment.center,
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: etiqueta4.map((etiqueta) => _buildEtiqueta(etiqueta)).toList(),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Lista de likes',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 20),
                              if (favoritos.isEmpty)
                                Text(
                                  'No hay elementos en la lista de likes.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                )
                              else
                                Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: favoritos.map((favorito) => SizedBox(
                                    width: MediaQuery.of(context).size.width / 2 - 15,
                                    child: _buildFavorito(favorito),
                                  )).toList(),
                                ),
                              SizedBox(height: 20),
                            ],
                          );
                        } else {
                          return Center(child: Text('Nombre de Usuario no disponible'));
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtiqueta(String etiqueta) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 212, 232, 1.0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        etiqueta,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildFavorito(dynamic favorito) {
    String nombreFavorito;
    String apodoFavorito;
    String urlFavorito;

    if (favorito is Map<String, dynamic>) {
      nombreFavorito = favorito['nombre'] ?? 'Sin nombre';
      apodoFavorito = favorito['apodo'] ?? 'Sin apodo';
      urlFavorito = favorito['url'] ?? 'assets/match3.png';
    } else {
      nombreFavorito = 'Tipo desconocido';
      apodoFavorito = 'Sin apodo';
      urlFavorito = 'assets/match3.png';
    }

    return Stack(
      children: [
        Container(
          width: 240,
          height: 240,
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 212, 232, 1.0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(urlFavorito),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              SizedBox(height: 10),
              Text(
                apodoFavorito,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 5),
              Text(
                nombreFavorito,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 25,
          right: 20,
          child: GestureDetector(
            onTap: () async {
              await _eliminarFavorito(favorito);
            },
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
