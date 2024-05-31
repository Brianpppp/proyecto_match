import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todolist_firebase/screens/login_registro_screen.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'preguntas_usuario.dart'; // Importa la página de preguntas del usuario

class UserPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _deleteAccount(BuildContext context) async {
    User? user = _auth.currentUser;

    if (user != null) {
      String? email = user.email;  // Obtener el correo electrónico del usuario
      if (email != null) {
        try {
          // Agregar depuración para verificar el email
          print('Email del usuario actual: $email');

          // Primero, elimina los datos del usuario en Firestore utilizando el email como ID
          await _firestore.collection('usuarios').doc(email).delete();
          print('Documento de Firestore eliminado correctamente');

          // Luego, elimina el usuario de Firebase Auth
          await user.delete();
          print('Usuario de Firebase Auth eliminado correctamente');

          // Navegar a la pantalla de inicio de sesión
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
                (Route<dynamic> route) => false,
          );
        } catch (e) {
          // Manejo de errores
          print('Error al eliminar la cuenta: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al eliminar la cuenta: $e')),
          );
        }
      } else {
        print('El usuario no tiene un correo electrónico asociado.');
      }
    } else {
      print('No hay usuario autenticado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Header(),
          Expanded(
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        'Mi cuenta',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 50),

                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        'Información personal',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/personal_info');
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.delete),
                      title: Text(
                        'Eliminar cuenta',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () async {
                        bool confirm = await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Confirmar eliminación'),
                              content: Text('¿Estás seguro de que deseas eliminar tu cuenta? Esta acción no se puede deshacer.'),
                              actions: [
                                TextButton(
                                  child: Text('Cancelar'),
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                ),
                                TextButton(
                                  child: Text('Eliminar'),
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        if (confirm) {
                          await _deleteAccount(context);
                        }
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.logout),
                      title: Text(
                        'Cerrar sesión',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => AuthScreen()),
                        );
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.question_answer),
                      title: Text(
                        'Responder Preguntas',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => PreguntasUsuario()),
                        );
                      },
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
