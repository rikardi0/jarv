import 'package:flutter/material.dart';
import 'package:jarv/app/feature/proveedor/data/model/argument_proveedor.dart';
import 'package:jarv/app/feature/proveedor/data/model/entity_proveedor.dart';
import 'package:jarv/app/feature/proveedor/data/repositories/interfaces/proveedor_repository.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';
import 'package:jarv/shared/ui/widget/filter_familia_subfamilia.dart';

class CreateProveedor extends StatefulWidget {
  const CreateProveedor({super.key});
  static const routeName = '/create_proveedor';

  @override
  State<CreateProveedor> createState() => _CreateProveedorState();
}

class _CreateProveedorState extends State<CreateProveedor> {
  final TextEditingController _empresaNameController = TextEditingController();

  final TextEditingController _cifController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _telefonoController = TextEditingController();

  final fechtRepository = localService<ProveedorRepository>();

  String familiaId = '';

  String? subFamilia;

  String? familia;

  Map<String, String> listaRubro = {};

  @override
  Widget build(BuildContext context) {
    final ArgumentProveedor argument =
        ModalRoute.of(context)?.settings.arguments as ArgumentProveedor;

    if (argument.listaRubro.isNotEmpty) {
      listaRubro = argument.listaRubro;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(argument.listaRubro.isEmpty
            ? 'Nuevo Proveedor'
            : 'Editar Proveedor'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SafeArea(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: CustomTextField(
                                        label: 'Empresa',
                                        value: _empresaNameController.text,
                                        controller: _empresaNameController,
                                        keyboard: TextInputType.name)),
                                Expanded(
                                    child: CustomTextField(
                                        label: 'Telefono',
                                        value: _telefonoController.text,
                                        controller: _telefonoController,
                                        keyboard: TextInputType.name)),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.175,
                                    child: CustomTextField(
                                        label: 'CIF',
                                        value: _cifController.text,
                                        controller: _cifController,
                                        keyboard: TextInputType.number))
                              ],
                            ),
                            CustomTextField(
                                label: 'Correo',
                                value: _emailController.text,
                                controller: _emailController,
                                keyboard: TextInputType.emailAddress),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _buildRowRubroSelector(),
                            ),
                            _buildMapRubro(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildImageContainer(context),
                ],
              ),
            ),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Row _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledButton.tonalIcon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
            label: const Text('Borrar')),
        FilledButton.icon(
            onPressed: () {
              listaRubro.forEach((key, value) {
                fechtRepository.insertFamiliaProveedor(FamiliaProveedor(
                    cif: _cifController.text,
                    nombreFamilia: key,
                    nombreSubFamilia: value,
                    familiaId:
                        DateTime.now().microsecondsSinceEpoch.toString()));
              });

              fechtRepository.insertProveedor(Proveedor(
                  cif: _cifController.text,
                  nombreEmpresa: _empresaNameController.text,
                  numero: _telefonoController.text,
                  email: _emailController.text));
            },
            icon: const Icon(Icons.save),
            label: const Text('Guardar')),
      ],
    );
  }

  Padding _buildMapRubro(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black54),
            borderRadius: BorderRadius.circular(10)),
        height: MediaQuery.of(context).size.height * 0.25,
        child: ListView.builder(
          itemCount: listaRubro.length,
          itemBuilder: (context, index) {
            String itemNombreFamilia = listaRubro.keys.elementAt(index);
            String itemSubFamilia = listaRubro[itemNombreFamilia]!;
            return ListTile(
              title: Text(itemNombreFamilia),
              subtitle: Text(itemSubFamilia),
              trailing: GestureDetector(
                  onTap: () {
                    setState(() {
                      listaRubro.remove(itemNombreFamilia);
                    });
                  },
                  child: const Icon(Icons.remove_circle_outline_outlined)),
            );
          },
        ),
      ),
    );
  }

  Row _buildRowRubroSelector() {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FamiliaSelector(
                familia: familia,
                onChanged: (value) {
                  setState(() {
                    familiaId = value!;
                    subFamilia = null;
                  });
                }),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: SubFamiliaSelector(
                familiaId: familiaId,
                subFamilia: subFamilia,
                onChanged: (value) {
                  setState(() {
                    subFamilia = value;
                  });
                }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: StreamBuilder(
              stream: fechtRepository.findFamiliaById(familiaId),
              builder: (context, snapshot) {
                return FilledButton(
                    style: FilledButton.styleFrom(),
                    onPressed: subFamilia == null
                        ? null
                        : () {
                            setState(() {
                              listaRubro[snapshot.data!.nombreFamilia] =
                                  subFamilia!;
                              subFamilia = null;
                              familia = null;
                            });
                          },
                    child: const Text('Agregar'));
              }),
        )
      ],
    );
  }

  SafeArea _buildImageContainer(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.height * 0.45,
              child: const Card(
                elevation: 15.0,
              ),
            ),
            ElevatedButton(onPressed: () {}, child: const Text('Agregar Foto')),
          ],
        ),
      ),
    );
  }
}
