import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:jarv/src/utils/models/producto_espera.dart';
import 'package:jarv/src/utils/provider/venta_espera_provider.dart';
import 'package:jarv/src/widgets/app_bar_item.dart';
import 'package:jarv/src/widgets/factura_fiscal.dart';
import 'package:provider/provider.dart';

import '../../widgets/card_venta.dart';

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
        title: selectedVenta.value != null || listaProductoEspera.isEmpty
            ? appBarActions(listaProductoEspera)
            : const Text('Ventas en Espera'),
      ),
      body: listaProductoEspera.isEmpty
          ? listaEsperaVacia()
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * 0.4,
                  child: ListView.builder(
                      itemCount: listaProductoEspera.length,
                      itemBuilder: (context, index) {
                        return CardVenta(
                          index: index,
                          selected: selectedVenta,
                          listaProductos: listaProductoEspera,
                          color: Theme.of(context).primaryColor,
                          action: actionItem,
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

  actionItem(index) {
    if (selectedVenta.value != index) {
      selectedVenta.value = index;
    } else {
      selectedVenta.value = null;
    }
    setState(() {});
  }

  Center listaEsperaVacia() {
    return const Center(
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
                selectedVenta.value = null;
              }
              setState(() {});
            },
            child:
                const AppBarItemButton(icon: Icons.delete, label: 'Eliminar')),
        GestureDetector(
            onTap: () {
              context
                  .read<VentaEsperaProvider>()
                  .changeBool(productoEspera: true);
              context
                  .read<VentaEsperaProvider>()
                  .changePosicionEspera(nuevaPosicion: selectedVenta.value);
              Navigator.pushNamed(context, '/menu');
            },
            child: const AppBarItemButton(
                icon: Icons.edit_note_rounded, label: 'Editar')),
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
}
