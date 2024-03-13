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
        ),
        body: Row(
          children: [
            filterCliente(context, size),
            VerticalDivider(
              endIndent: 20.0,
              width: 10,
              color: Theme.of(context).colorScheme.onSurface,
            ),
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
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceVariant
                      .withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10)),
              width: size.width * 0.35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.5),
                child: ListView(
                  children: [
                    textField('Nombre', TextInputType.name),
                    textField('Telefono', TextInputType.phone),
                    textField('NIF', TextInputType.none),
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

  TextFormField textField(String label, TextInputType type) {
    return TextFormField(
      onFieldSubmitted: (value) {},
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.search),
      ),
    );
  }
}
