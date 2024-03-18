import 'package:flutter/material.dart';

class CardCliente extends StatelessWidget {
  const CardCliente(
      {super.key, required this.direccionCliente, required this.nombreCliente});
  final String nombreCliente;
  final String direccionCliente;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(nombreCliente),
        subtitle: Text(direccionCliente),
        trailing: FittedBox(
          child: Column(
            children: [
              ElevatedButton(onPressed: () {}, child: const Text('Editar')),
              const Text('B8bJKX')
            ],
          ),
        ),
      ),
    );
  }
}
