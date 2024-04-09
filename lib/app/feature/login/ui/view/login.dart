import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/data/repository/interface/login_repository.dart';
import 'package:jarv/app/feature/login/data/repository/interface/prueba_repository.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/card_button.dart';

import '../../../venta/data/model/entity_venta.dart';
import '../../data/model/entity_login.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({
    super.key,
  });

  static const routeName = "/login";
  final fetchUsuario = localService<LoginRepository>();
  final fetchPrueba = localService<PruebaRepository>();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final selectedUserIndex = ValueNotifier<int?>(null);

  @override
  Widget build(BuildContext context) {
    final Future<List<Usuario>> listUsuarios =
        widget.fetchUsuario.findAllUsuarios();

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
                        widget.fetchPrueba.insertarTipoVenta(
                            TipoVenta(idTipoVenta: 0, tipoVenta: 'regular'));
                        widget.fetchPrueba.insertarTipoVenta(TipoVenta(
                            idTipoVenta: 1, tipoVenta: 'consumicion propia'));
                        widget.fetchPrueba.insertarTipoVenta(
                            TipoVenta(idTipoVenta: 2, tipoVenta: 'devolucion'));
                        widget.fetchPrueba.insertarTipoDevolucion(Devolucion(
                            idDevolucion: 0,
                            devolucion: 'producto incorrecto'));
                        widget.fetchPrueba.insertarTipoDevolucion(Devolucion(
                            idDevolucion: 1,
                            devolucion: 'producto en mal estado'));
                        for (var i = 0; i < 12; i++) {
                          widget.fetchPrueba.insertarProducto(Producto(
                              i,
                              'producto $i',
                              10.0,
                              10.0,
                              0.1,
                              'idSubfamilia $i',
                              5));
                          widget.fetchPrueba.insertarFamilia(Familia(
                              'idFamilia $i',
                              'nombreFamilia $i',
                              'idUsuario $i'));
                          widget.fetchPrueba.insertarSubFamilia(SubFamilia(
                              'idSubfamilia $i',
                              'nombreSub $i',
                              'idFamilia $i'));
                          widget.fetchPrueba.insertarCliente(Cliente(
                              idCliente: i,
                              nombreCliente: 'nombreCliente $i',
                              telefono: 'telefono $i',
                              email: 'email $i',
                              puntos: i,
                              nombreTienda: 'nombreTienda $i',
                              nif: 'NIF $i',
                              direccion: 'direccion $i',
                              fechaNacimiento: 'fechaNacimiento $i',
                              genero: true,
                              pedidos: 0));
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
