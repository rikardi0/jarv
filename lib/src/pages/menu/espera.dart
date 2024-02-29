import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/arguments_venta_espera.dart';

class Espera extends StatelessWidget {
  const Espera({super.key});

  static const routeName = '/espera';
  @override
  Widget build(BuildContext context) {
    final VentaEsperaArgument argument =
        ModalRoute.of(context)!.settings.arguments as VentaEsperaArgument;
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: size.width * 0.25,
              child: ListView.builder(
                  itemCount: argument.productoEspera.length,
                  itemBuilder: (context, index) {
                    final productoEspera = argument.productoEspera[index];
                    final identificador = argument.identificador;
                    return Card(
                        child: ListTile(
                      leading: Text(identificador[index]!),
                      title: Text(productoEspera!.nombreProducto),
                      subtitle: Text(productoEspera.productoId),
                    ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
