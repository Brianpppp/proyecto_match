
import 'package:flutter/material.dart';
import '../components/footer.dart';
import '../components/header.dart';

class StorePage extends StatelessWidget {
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
                child: Text('puntos de compras'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}