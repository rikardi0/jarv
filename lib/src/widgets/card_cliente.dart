import 'package:flutter/material.dart';

class CardCliente extends StatelessWidget {
  const CardCliente({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: const Text('Nombre Cliente'),
            subtitle: const Text('Direccion'),
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
      },
    );
  }
}
