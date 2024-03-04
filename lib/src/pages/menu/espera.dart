import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:jarv/src/utils/models/producto_espera.dart';
import 'package:jarv/src/utils/provider/venta_espera_provider.dart';
import 'package:jarv/src/widgets/app_bar_item.dart';
import 'package:jarv/src/widgets/factura_fiscal.dart';
import 'package:provider/provider.dart';

class Espera extends StatefulWidget {
  const Espera({super.key});

  static const routeName = '/espera';

  @override
  State<Espera> createState() => _EsperaState();
}

class _EsperaState extends State<Espera> {
  final selectedVenta = ValueNotifier<int?>(null);
  @override
  Widget build(BuildContext context) {
    final List<ProductoEspera> listaProductoEspera =
        context.watch<VentaEsperaProvider>().listaEspera;

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: selectedVenta.value != null || listaProductoEspera.isEmpty
            ? appBarActions(listaProductoEspera)
            : const Text('Ventas en Espera'),
        toolbarHeight: 65,
        backgroundColor: const Color.fromARGB(255, 170, 117, 255),
      ),
      body: listaProductoEspera.isEmpty
          ? const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Sin ventas en espera',
                      style: TextStyle(fontSize: 20, color: Colors.black54),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.25,
                  child: ListView.builder(
                      itemCount: listaProductoEspera.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (selectedVenta.value != index) {
                              selectedVenta.value = index;
                            } else {
                              selectedVenta.value = null;
                            }
                            setState(() {});
                          },
                          child: _itemEspera(index, context,
                              listaProductoEspera, Colors.deepPurpleAccent),
                        );
                      }),
                ),
                selectedVenta.value != null
                    ? FacturaFiscal(
                        listaProducto: listaProductoEspera[selectedVenta.value!]
                            .listaProducto,
                        impuesto: 0.25,
                        tipoPago: '',
                        precioVenta: listaProductoEspera[selectedVenta.value!]
                            .totalVenta)
                    : const SizedBox.shrink()
              ],
            ),
    );
  }

  Row appBarActions(List<ProductoEspera> listaProducto) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
            onTap: () {
              if (selectedVenta.value != null) {
                listaProducto.removeAt(selectedVenta.value!);
              }
              setState(() {});
            },
            child:
                const AppBarItemButton(icon: Icons.delete, label: 'Eliminar')),
        GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/venta',
                  arguments: CheckOutArgument(
                      productoAgregado:
                          listaProducto[selectedVenta.value!].listaProducto,
                      totalVenta:
                          listaProducto[selectedVenta.value!].totalVenta!));
            },
            child: const AppBarItemButton(
                icon: Icons.euro_rounded, label: 'Pagar'))
      ],
    );
  }

  Card _itemEspera(int index, BuildContext context,
      List<ProductoEspera> listaProductoEspera, Color color) {
    return Card(
      color: selectedVenta.value != index
          ? Theme.of(context).cardTheme.color
          : Colors.transparent,
      elevation: selectedVenta.value != index
          ? Theme.of(context).cardTheme.elevation
          : 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color:
                  selectedVenta.value == index ? color : Colors.transparent)),
      child: ListTile(
          leading: Text(listaProductoEspera[index].identificadorVenta!),
          subtitle:
              Text('${listaProductoEspera[index].totalVenta.toString()} €'),
          title: Text(
            'Productos: ${listaProductoEspera[index].listaProducto.length.toString()}',
            style: TextStyle(
                color: selectedVenta.value == index
                    ? color
                    : Theme.of(context).listTileTheme.textColor),
          )),
    );
  }
}
