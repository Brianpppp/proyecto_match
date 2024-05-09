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
            top: MediaQuery.of(context).padding.top + 60, // Ajusta la posición superior según tus necesidades
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      // Puedes agregar la imagen de perfil aquí
                      // backgroundImage: AssetImage('assets/user_profile_image.jpg'),
                    ),
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
                var etiqueta1 = userData['etiqueta1']; // Obtener etiqueta1
                var etiqueta2 = userData['etiqueta2']; // Obtener etiqueta2
                var etiqueta4 = userData['etiqueta4']; // Obtener etiqueta4
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(
                      username ?? 'Nombre de Usuario no disponible',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showEditProfileModal(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20), // Ajusta el padding
                        minimumSize: Size(0, 40), // Establece un ancho mínimo y un alto
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
                    _buildEtiqueta('$etiqueta1'),
                    _buildEtiqueta('$etiqueta2'),
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
                    _buildEtiqueta('$etiqueta4'),
                    SizedBox(height: 20),

                    SizedBox(height: 10),
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
      MaterialPageRoute(builder: (BuildContext context) => Info()),
    );
  }
}
