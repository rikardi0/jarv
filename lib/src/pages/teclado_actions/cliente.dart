import 'package:flutter/material.dart';
import 'package:jarv/src/data_source/db.dart';
import '../../widgets/card_cliente.dart';

class ClienteMenu extends StatefulWidget {
  const ClienteMenu({super.key, required this.cliente});

  static const routeName = '/cliente';
  final ClienteDao cliente;

  @override
  State<ClienteMenu> createState() => _ClienteMenuState();
}

class _ClienteMenuState extends State<ClienteMenu> {
  List<Cliente> items = [];
  @override
  Widget build(BuildContext context) {
    final clientes = widget.cliente.findAllClientes().asStream();

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
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: StreamBuilder(
                      stream: clientes,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text('Sin Cliente'),
                          );
                        } else {
                          final clienteInfo = snapshot.data;

                          return ListView.builder(
                              itemCount: clienteInfo?.length,
                              itemBuilder: (context, index) {
                                return CardCliente(
                                    direccionCliente:
                                        clienteInfo![index].nombreTienda,
                                    nombreCliente:
                                        clienteInfo[index].nombreCliente);
                              });
                        }
                      }),
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
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              width: size.width * 0.35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.5),
                child: ListView(
                  children: [
                    textField('Nombre', TextInputType.name),
                    textField('NIF', TextInputType.name),
                    textField('Telefono', TextInputType.phone),
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

  Widget textField(
    String label,
    TextInputType type,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        keyboardType: type,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          labelText: label,
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
