import 'package:flutter/material.dart';

class CardCliente extends StatelessWidget {
  const CardCliente(
      {super.key,
      required this.direccionCliente,
      required this.nombreCliente,
      required this.nifCliente,
      required this.onPressEditar});
  final String nombreCliente;
  final String direccionCliente;
  final String nifCliente;
  final dynamic onPressEditar;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(nombreCliente),
        subtitle: Text(direccionCliente),
        trailing: FittedBox(
          child: Column(
            children: [
              ElevatedButton(
                  onPressed: () {
                    onPressEditar();
                  },
                  child: const Text('Editar')),
              Text(nifCliente)
            ],
          ),
        ),
      ),
    );
  }
}
