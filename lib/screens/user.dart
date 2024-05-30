import 'package:flutter/material.dart';
import 'package:todolist_firebase/screens/login_registro_screen.dart';
import '../components/header.dart';
import '../components/footer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'preguntas_usuario.dart'; // Importa la página de preguntas del usuario

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Header(), // Mantenemos el encabezado
          Expanded(
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0), // Mantenemos el color de fondo
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
                          fontSize: 24, // Tamaño del texto aumentado
                          fontWeight: FontWeight.w900, // Mayor peso para resaltar más
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // Añade espacio vertical entre las cajas

                    ListTile(
                      leading: Icon(Icons.person),
                      title: Text(
                        'Información personal',
                        style: TextStyle(fontSize: 18),
                      ),
                      onTap: () {
                        // Navegar a la pantalla de información personal al hacer clic
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
                      onTap: () {
                        // Navegar a la pantalla de eliminación de cuenta al hacer clic
                        Navigator.pushNamed(context, '/delete_account');
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
                        // Realizar la acción de cerrar sesión al hacer clic
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
                        // Realizar la acción de cerrar sesión al hacer clic

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => PreguntasUsuario()),
                        );
                      },  //OnTap
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
