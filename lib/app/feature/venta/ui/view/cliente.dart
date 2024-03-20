import 'package:flutter/material.dart';
import '../../../../../shared/ui/card_cliente.dart';
import '../../data/data-sources/dao_venta.dart';
import '../../data/model/entity_venta.dart';

class ClienteMenu extends StatefulWidget {
  const ClienteMenu({super.key, required this.cliente});

  static const routeName = '/cliente';
  final ClienteDao cliente;

  @override
  State<ClienteMenu> createState() => _ClienteMenuState();
}

class _ClienteMenuState extends State<ClienteMenu> {
  List<Cliente> clienteLista = [];
  final TextEditingController _nameSearchController = TextEditingController();
  final TextEditingController _nifSearchController = TextEditingController();
  final TextEditingController _direccionSearchController =
      TextEditingController();
  String nameSearchText = '';
  String nifSearchText = '';
  String direccionSearchText = '';
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
                          clienteLista = snapshot.data!;
                          _searchFilter();

                          return ListView.builder(
                              itemCount: clienteLista.length,
                              itemBuilder: (context, index) {
                                return CardCliente(
                                  direccionCliente:
                                      clienteLista[index].direccion,
                                  nombreCliente:
                                      clienteLista[index].nombreCliente,
                                  nifCliente: clienteLista[index].nif,
                                );
                              });
                        }
                      }),
                ),
              ),
            ),
          ],
        ));
  }

  void _searchFilter() {
    if (nameSearchText.isNotEmpty ||
        nifSearchText.isNotEmpty ||
        direccionSearchText.isNotEmpty) {
      clienteLista = clienteLista.where((element) {
        return element.nombreCliente
            .toString()
            .toLowerCase()
            .contains(nameSearchText.toLowerCase());
      }).toList();
      clienteLista = clienteLista.where((element) {
        return element.nif
            .toString()
            .toLowerCase()
            .contains(nifSearchText.toLowerCase());
      }).toList();
      clienteLista = clienteLista.where((element) {
        return element.direccion
            .toString()
            .toLowerCase()
            .contains(direccionSearchText.toLowerCase());
      }).toList();
    }
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
                    textField(
                        'Nombre', TextInputType.name, _nameSearchController,
                        (value) {
                      nameSearchText = value;
                      setState(() {});
                    }),
                    textField('NIF', TextInputType.name, _nifSearchController,
                        (value) {
                      nifSearchText = value;
                      setState(() {});
                    }),
                    textField('Direccion', TextInputType.streetAddress,
                        _direccionSearchController, (value) {
                      direccionSearchText = value;
                      setState(() {});
                    }),
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
    TextEditingController controller,
    dynamic onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          onChanged(value);
        },
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
