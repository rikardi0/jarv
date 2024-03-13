import 'package:flutter/material.dart';
import 'package:jarv/src/data_source/db.dart';
import 'package:jarv/src/widgets/card_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.usuarios,
    required this.familia,
    required this.subFamilia,
    required this.producto,
  });

  final UsuarioDao usuarios;
  final FamiliaDao familia;
  final SubFamiliaDao subFamilia;
  final ProductoDao producto;

  static const routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final selectedUserIndex = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    final Future<List<Usuario>> listUsuarios =
        widget.usuarios.findAllUsuarios();

    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: Text("JARV")),
        centerTitle: true,
        title: const Text("dd/mm/aaaa"),
        actions: [
          Center(
              child: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ))
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: FutureBuilder(
                    future: listUsuarios,
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      return GridView.builder(
                        itemCount: user?.length ?? 0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 10,
                                mainAxisExtent: 180),
                        itemBuilder: (context, index) {
                          final userUser = user![index];
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedUserIndex.value == index) {
                                    selectedUserIndex.value = null;
                                  } else {
                                    selectedUserIndex.value = index;
                                  }
                                });
                              },
                              child: CardButton(
                                  content: userUser.nombre,
                                  valueNotifier: selectedUserIndex,
                                  colorSelected: Theme.of(context)
                                      .listTileTheme
                                      .selectedTileColor!,
                                  posicion: index));
                        },
                      );
                    }),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: true,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextFormField(
                        decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: 'Password',
                    )),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/menu");
                      },
                      child: const Text("Ingresar")),
                  ElevatedButton(
                      onPressed: () {
                        for (var i = 0; i < 12; i++) {
                          widget.producto.insertProducto(Producto(
                              'productoId $i',
                              'producto $i',
                              10.0,
                              10.0,
                              10.0,
                              'idSubfamilia $i',
                              5));
                          widget.familia.insertFamilia(Familia('idFamilia $i',
                              'nombreFamilia $i', 'idUsuario $i'));
                          widget.subFamilia.insertSubFamilia(SubFamilia(
                              'idSubfamilia $i',
                              'nombreSub $i',
                              'idFamilia $i'));
                        }
                      },
                      child: const Text("Agregar Datos")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
