import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';
import 'package:jarv/src/utils/provider/venta_espera_provider.dart';
import 'package:provider/provider.dart';

class Espera extends StatelessWidget {
  const Espera({super.key});

  static const routeName = '/espera';
  @override
  Widget build(BuildContext context) {
    final List<ProductoPreOrdenado?> listaProductos =
        context.watch<VentaEsperaProvider>().listaProducto;

    final List<String?> listaId =
        context.watch<VentaEsperaProvider>().identficadoresVenta;

    final List<double?> listaTotal =
        context.watch<VentaEsperaProvider>().totalVenta;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: size.width * 0.25,
              child: ListView.builder(
                  itemCount: listaId.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                      leading: Text(listaId[index]!),
                      title: Text(listaTotal[index].toString()),
                      subtitle: Text(listaProductos.length.toString()),
                    ));
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
