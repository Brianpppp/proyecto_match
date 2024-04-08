
import 'package:flutter/material.dart';
import '../components/footer.dart';

class StorePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tienda')),
      body: Center(child: Text('Puntos de Tienda')),
      bottomNavigationBar: Footer(),
    );
  }
}