import 'package:flutter/material.dart';

class Proveedor extends StatelessWidget {
  const Proveedor({super.key});

  static const routeName = '/proveedores';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedor'),
      ),
      body: Container(),
    );
  }
}
