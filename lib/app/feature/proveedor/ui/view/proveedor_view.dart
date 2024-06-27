import 'package:flutter/material.dart';
import 'package:jarv/app/feature/proveedor/data/model/argument_proveedor.dart';
import 'package:jarv/app/feature/proveedor/data/model/entity_proveedor.dart';
import 'package:jarv/app/feature/proveedor/data/repositories/interfaces/proveedor_repository.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/widget/filter_familia_subfamilia.dart';
import 'package:jarv/shared/ui/widget/search_field.dart';

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

  final fecthProveedorRepository = localService<ProveedorRepository>();

  final selectedProveedor = ValueNotifier<int?>(null);

  List<Proveedor> listaProveedor = [];

  String familiaId = '';
  String? subFamilia;
  String? familia;

  bool filtroAvanzado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proveedores'),
        actions: [
          MainFilter(
            familia: familia,
            familiaId: familiaId,
            subFamilia: subFamilia,
            onChangeFamilia: (value) {
              setState(() {
                familiaId = value!;
                subFamilia = null;
              });
            },
            onChangeSubFamilia: (value) {
              setState(() {
                subFamilia = value;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCheckBox(),
                    _buildColumnFilter(context),
                    _buildButtonAction(),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: _buildListProveedor(),
            ),
          ],
        ),
      ),
    );
  }

  Visibility _buildColumnFilter(BuildContext context) {
    return Visibility(
      visible: filtroAvanzado,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width / 4.75,
            height: MediaQuery.of(context).size.height / 6.15,
            child: SearchField(
                onChanged: (value) {
                  setState(() {
                    _cifController.text = value;
                  });
                },
                label: 'CIF',
                type: TextInputType.number,
                controller: _cifController),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4.75,
            height: MediaQuery.of(context).size.height / 6.15,
            child: SearchField(
                onChanged: (value) {
                  setState(() {
                    _empresaNameController.text = value;
                  });
                },
                label: 'Nombre Empresa',
                type: TextInputType.name,
                controller: _empresaNameController),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 4.75,
            height: MediaQuery.of(context).size.height / 6.15,
            child: SearchField(
                onChanged: (value) {
                  setState(() {
                    _telefonoController.text = value;
                  });
                },
                label: 'Telefono',
                type: TextInputType.phone,
                controller: _telefonoController),
          ),
        ],
      ),
    );
  }

  Row _buildCheckBox() {
    return Row(
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
    );
  }

  Widget _buildButtonAction() {
    return FilledButton.icon(
        onPressed: () {
          //   for (var i = 0; i < 5; i++) {
          //     fecthProveedorRepository.insertProveedor(Proveedor(
          //         cif: 'cif $i',
          //         nombreEmpresa: 'nombreEmpresa $i',
          //         idFamilia: 'idFamilia $i',
          //         idSubFamilia: 'idSubFamilia $i',
          //         numero: 'numero $i',
          //         email: 'email $i'));
          //   }
          Navigator.pushNamed(context, '/create_proveedor',
              arguments: ArgumentProveedor.empty());
        },
        icon: const Icon(Icons.add_box),
        label: const Text('Agregar Proveedor'));
  }

  Widget _buildListProveedor() {
    return FutureBuilder(
        future: fecthProveedorRepository.findAllProveedores(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            listaProveedor = snapshot.data!;
            _searchFilter();
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: listaProveedor.length,
                itemBuilder: (context, index) {
                  return _cardProveedor(index, context);
                });
          } else {
            return Container();
          }
        });
  }

  Padding _cardProveedor(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ListTile(
              title: Text(listaProveedor[index].nombreEmpresa),
              leading: Container(
                  height: 75,
                  width: 75,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outline),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 25.0),
                    child: Text(
                      listaProveedor[index].numero,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )),
              subtitle: Text(listaProveedor[index].cif),
              trailing: ElevatedButton(
                onPressed: () async {
                  final Map<String, String> listaRubro = {};

                  setState(() {
                    Navigator.pushNamed(context, '/create_proveedor',
                        arguments: ArgumentProveedor(
                            nombreEmpresa: listaProveedor[index].nombreEmpresa,
                            telefono: listaProveedor[index].numero,
                            cif: listaProveedor[index].cif,
                            correo: listaProveedor[index].email,
                            listaRubro: listaRubro));
                  });
                },
                child: const Text('Editar'),
              )),
        ),
      ),
    );
  }

  void _searchFilter() {
    if (_cifController.text.isNotEmpty ||
        _empresaNameController.text.isNotEmpty ||
        _telefonoController.text.isNotEmpty) {
      listaProveedor = listaProveedor.where((element) {
        return element.nombreEmpresa
            .toString()
            .toLowerCase()
            .contains(_empresaNameController.text.toLowerCase());
      }).toList();
      listaProveedor = listaProveedor.where((element) {
        return element.cif
            .toString()
            .toLowerCase()
            .contains(_cifController.text.toLowerCase());
      }).toList();
      listaProveedor = listaProveedor.where((element) {
        return element.numero
            .toString()
            .toLowerCase()
            .contains(_telefonoController.text.toLowerCase());
      }).toList();
    }
  }
}
