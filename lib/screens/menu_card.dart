
import 'package:flutter/material.dart';
import '../components/footer.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Menú')),
      body: Center(child: Text('carta de hamburguesas ')),
      bottomNavigationBar: Footer(),
    );
  }
}