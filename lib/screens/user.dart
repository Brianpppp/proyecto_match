import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/footer.dart';

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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                        _signOut(context);
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

  // Función para cerrar sesión
  void _signOut(BuildContext context) async {
    // Aquí deberías realizar las operaciones necesarias para cerrar sesión, como cerrar la sesión en Firebase Auth, etc.
    // Después de cerrar sesión, puedes navegar a la pantalla de inicio de sesión o a cualquier otra pantalla necesaria.
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}
