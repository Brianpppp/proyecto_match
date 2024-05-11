import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/header.dart';
import '../components/footer.dart';

class Info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Header(),
          ),
          Positioned.fill(
            top: MediaQuery.of(context).padding.top + 60,
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: _buildUserInfo(context),
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

  Widget _buildUserInfo(BuildContext context) {
    return FutureBuilder<User?>(
      future: _getCurrentUser(),
      builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return Center(child: Text('Error: ${userSnapshot.error}'));
        }
        if (userSnapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('usuarios').doc(userSnapshot.data!.email).get(),
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
                var puntos = userData['puntos'] ?? 0; // Obtener los puntos del usuario
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Información personal',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      // Puedes agregar la imagen de perfil aquí
                      // backgroundImage: AssetImage('assets/user_profile_image.jpg'),
                    ),
                    SizedBox(height: 20),
                    Text(
                      username ?? 'Nombre de Usuario no disponible',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12, 12, 20, 20), // Ajusta el espacio arriba y a los lados según sea necesario
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Por cada 1€ de compra que hagas en nuestro restaurante acumularás 10 puntos.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 10), // Añade un espacio entre los textos
                          Row(
                            children: [
                              SizedBox(width: 10),
                              // Aquí agregamos el círculo de progreso con solo los puntos y de color rojo
                              Stack(
                                alignment: Alignment.center,

                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    child: CircularProgressIndicator(
                                      value: puntos / 225, // El valor máximo es 225
                                      strokeWidth: 8,
                                      backgroundColor: Colors.grey.withOpacity(0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red), // Color rojo
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      '$puntos',
                                      style: TextStyle(
                                        fontSize: MediaQuery.of(context).size.width * 0.04,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black, // Cambiar el color del texto según sea necesario
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
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
                        backgroundColor: Color.fromRGBO(226, 169, 209, 1.0),
                      ),
                      child: Text(
                        'Editar perfil',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Gustos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0, // Espacio horizontal entre las etiquetas
                      runSpacing: 10.0, // Espacio vertical entre las líneas
                      children: [
                        _buildEtiqueta(etiqueta1),
                        _buildEtiqueta(etiqueta2),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Likes',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10.0, // Espacio horizontal entre las etiquetas
                      runSpacing: 10.0, // Espacio vertical entre las líneas
                      children: etiqueta4.map((etiqueta) => _buildEtiqueta(etiqueta)).toList(),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              } else {
                return Center(child: Text('Nombre de Usuario no disponible'));
              }
            },
          );
        } else {
          return Center(child: Text('Nombre de Usuario no disponible'));
        }
      },
    );
  }

  Widget _buildEtiqueta(String etiqueta) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        etiqueta,
        style: TextStyle(
          fontSize: 18,
          color: Colors.black,
        ),
      ),
    );
  }

  Future<User?> _getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
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
                  FirebaseAuth auth = FirebaseAuth.instance;
                  User? user = auth.currentUser;
                  if (user != null) {
                    await FirebaseFirestore.instance.collection('usuarios').doc(user.email).update({'nombre': newUsername});
                    Navigator.pop(context); // Cerrar el modal
                    _refreshPage(context); // Recargar la página
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

  void _refreshPage(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (BuildContext context) => Info()),
    );
  }
}
