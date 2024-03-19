import 'package:flutter/material.dart';

class CardCliente extends StatelessWidget {
  const CardCliente(
      {super.key,
      required this.direccionCliente,
      required this.nombreCliente,
      required this.nifCliente});
  final String nombreCliente;
  final String direccionCliente;
  final String nifCliente;
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
              Text(nifCliente)
            ],
          ),
        ),
      ),
    );
  }
}
