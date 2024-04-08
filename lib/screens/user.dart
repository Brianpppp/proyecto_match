import 'package:flutter/material.dart';
import '../components/footer.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Usuario')),
      body: Center(child: Text('Perfil de Usuario')),
      bottomNavigationBar: Footer(),
    );
  }
}