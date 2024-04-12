import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Importa el paquete de Firebase Authentication
import '../components/header.dart';
import '../components/footer.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Footer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Header(), // Mantenemos el encabezado
          Expanded(
            child: Container(
              color: Color.fromRGBO(255, 169, 209, 1.0), // Mantenemos el color de fondo
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
                    SizedBox(height: 20),
                    Text(
                      'Nombre de Usuario',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 10),
                    FutureBuilder(
                      future: _getCurrentUserEmail(), // Obtener el correo electrónico del usuario actual
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator(); // Muestra un indicador de carga mientras se obtiene el correo electrónico
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
                        // Acción a realizar al presionar el botón de editar perfil
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      ),
                      child: Text(
                        'Editar perfil',
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

  // Función para obtener el correo electrónico del usuario actual
  Future<String> _getCurrentUserEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    if (user != null) {
      return user.email ?? 'Correo electrónico no disponible';
    } else {
      return 'Usuario no autenticado';
    }
  }
}
