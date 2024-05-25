import 'package:flutter/material.dart';
import 'package:jarv/app/feature/proveedor/data/repositories/interfaces/proveedor_repository.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/search_field.dart';

class ProveedorView extends StatefulWidget {
  const ProveedorView({super.key});

  static const routeName = '/proveedores';

  @override
  State<ProveedorView> createState() => _ProveedorViewState();
}

class _ProveedorViewState extends State<ProveedorView> {
  final TextEditingController _cifController = TextEditingController();

  final TextEditingController _empresaNameController = TextEditingController();

  final TextEditingController _telefonoController = TextEditingController();

  final fetchRepository = localService<ProveedorRepository>();

  bool filtroAvanzado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchFilter(context),
            Row(
              children: [
                Checkbox(
                    value: filtroAvanzado,
                    onChanged: (value) {
                      setState(() {
                        filtroAvanzado = !filtroAvanzado;
                      });
                    }),
                const Text('Filtro Avanzado'),
              ],
            ),
            _buildCardEmpresa(),
          ],
        ),
      ),
      bottomNavigationBar: _buildButtonAction(),
    );
  }

  Row _buildButtonAction() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add),
            label: const Text('Agregar Proveedor')),
        FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save),
            label: const Text('Guardar'))
      ],
    );
  }

  Expanded _buildCardEmpresa() {
    return Expanded(
      child: FutureBuilder(
          future: fetchRepository.findAllProveedores(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  clipBehavior: Clip.antiAlias,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final itemEmpresa = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: ListTile(
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(itemEmpresa![index].nombreEmpresa),
                                  Text(itemEmpresa[index].cif),
                                  Text(itemEmpresa[index].numero),
                                ],
                              ),
                              subtitle: GestureDetector(
                                child: const Row(
                                  children: [
                                    Text(
                                      'Expandir Tarjeta',
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 2.0),
                                      child: Icon(
                                        Icons.unfold_more,
                                        size: 15,
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ),
                    );
                  });
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }

  Widget _buildSearchFilter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.75,
          child: SearchField(
              label: 'CIF',
              type: TextInputType.number,
              controller: _cifController),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.75,
          child: SearchField(
              label: 'Nombre Empresa',
              type: TextInputType.name,
              controller: _empresaNameController),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3.75,
          child: SearchField(
              label: 'Telefono',
              type: TextInputType.phone,
              controller: _telefonoController),
        )
      ],
    );
  }
}
