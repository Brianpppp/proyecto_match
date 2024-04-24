import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'login_registro_screen.dart';

class info extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(),
          Expanded(
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      // Puedes agregar la imagen de perfil aquí
                      // backgroundImage: AssetImage('assets/user_profile_image.jpg'),
                    ),
                    FutureBuilder<User?>(
                      future: _getCurrentUser(),
                      builder: (BuildContext context, AsyncSnapshot<User?> userSnapshot) {
                        if (userSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (userSnapshot.hasError) {
                          return Text('Error: ${userSnapshot.error}');
                        }
                        if (userSnapshot.hasData) {
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection('usuarios').doc(userSnapshot.data!.email).get(),
                            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              if (snapshot.hasData && snapshot.data!.exists) {
                                var userData = snapshot.data!.data() as Map<String, dynamic>;
                                var username = userData['nombre'];
                                return Text(
                                  username ?? 'Nombre de Usuario no disponible',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              } else {
                                return Text(
                                  'Nombre de Usuario no disponible',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return Text(
                            'Nombre de Usuario no disponible',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<String>(
                      future: _getCurrentUserEmail(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }
                        if (snapshot.hasData) {
                          return Text(
                            'Correo electrónico: ${snapshot.data}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          );
                        } else {
                          return Text(
                            'Correo electrónico no disponible',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _showEditProfileModal(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Editar perfil',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AuthScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Cerrar sesión',
                        style: TextStyle(fontSize: 18),
                      ),
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

  Future<String> _getCurrentUserEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = await auth.currentUser;
    if (user != null) {
      return user.email ?? 'Correo electrónico no disponible';
    } else {
      return 'Usuario no autenticado';
    }
  }

  Future<User?> _getCurrentUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser;
  }

  void _showEditProfileModal(BuildContext context) {
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
      MaterialPageRoute(builder: (BuildContext context) => info()),
    );
  }
}