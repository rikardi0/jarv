import 'package:flutter/material.dart';
import '../../widgets/card_cliente.dart';

class ClienteMenu extends StatelessWidget {
  const ClienteMenu({super.key});

  static const routeName = '/cliente';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.75),
        ),
        body: Row(
          children: [
            filterCliente(context, size),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SizedBox(
                  height: size.height,
                  child: const CardCliente(),
                ),
              ),
            ),
          ],
        ));
  }

  Widget filterCliente(BuildContext context, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).highlightColor.withOpacity(0.35),
                  borderRadius: BorderRadius.circular(10)),
              width: size.width * 0.35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.5),
                child: ListView(
                  children: [
                    TextFormField(
                      onFieldSubmitted: (value) {},
                      decoration: const InputDecoration(
                        labelText: 'NIF',
                      ),
                    ),
                    TextFormField(
                      onFieldSubmitted: (value) {},
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      onFieldSubmitted: (value) {},
                      decoration: const InputDecoration(
                        labelText: 'Telefono',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onFieldSubmitted: (value) {},
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      onFieldSubmitted: (value) {},
                      decoration: const InputDecoration(labelText: 'Direccion'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Nuevo Cliente')),
          )
        ],
      ),
    );
  }
}
