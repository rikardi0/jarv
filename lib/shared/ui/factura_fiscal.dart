import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/data/model/producto_ordenado.dart';

class FacturaFiscal extends StatelessWidget {
  const FacturaFiscal({
    super.key,
    required this.listaProducto,
    required this.tipoPago,
    required this.precioVenta,
  });

  final List<ProductoOrdenado?> listaProducto;
  final String tipoPago;
  final double? precioVenta;

  @override
  Widget build(BuildContext context) {
    final totalFactura = listaProducto.fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          (element!.precio) *
              double.parse(element.cantidad) *
              (1 + (element.iva)),
    );
    final double sizeWidth = MediaQuery.of(context).size.width * 0.35;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.15))),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SizedBox(
            width: sizeWidth,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.15))),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const Text('TITULO EMPRESA'),
                    const Text('RIF'),
                    const Text('UBICACION'),
                    const Divider(),
                    Builder(
                      builder: (context) {
                        final productoOrdenado = listaProducto.last;
                        final fecha = productoOrdenado!.fecha;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(tipoPago == ''
                                ? 'Venta en Espera'
                                : 'Venta $tipoPago'),
                            Text(
                                '${fecha.day.toString()}/${fecha.month.toString()}/${fecha.year.toString()}'),
                            Text(
                                '${fecha.hour.toString()}: ${fecha.minute.toString()}')
                          ],
                        );
                      },
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listaProducto.length,
                        itemBuilder: (BuildContext context, int index) {
                          final productoOrdenado = listaProducto[index];

                          final precio =
                              double.parse(productoOrdenado!.cantidad) *
                                  productoOrdenado.precio;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                    '${productoOrdenado.nombreProducto} x ${productoOrdenado.cantidad}'),
                              ),
                              Text('${precio.toString()} €'),
                            ],
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        containerColumna(sizeWidth, 'Impuesto'),
                        containerColumna(sizeWidth, 'Base'),
                        containerColumna(sizeWidth, 'Cuota'),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: listaProducto.length,
                        itemBuilder: (context, index) {
                          final productoOrdenado = listaProducto[index];
                          final precio = productoOrdenado!.precio *
                              double.parse(productoOrdenado.cantidad);
                          final base = precio * productoOrdenado.iva;
                          final ivaPorcentaje =
                              (productoOrdenado.iva * 100).floor().toString();

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              containerColumna(sizeWidth, '$ivaPorcentaje %'),
                              containerColumna(sizeWidth, '$base'),
                              containerColumna(sizeWidth, '${precio + base}'),
                            ],
                          );
                        },
                      ),
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total'),
                        Text('${totalFactura.floorToDouble().toString()} €')
                      ],
                    ),
                    Visibility(
                      visible: tipoPago == 'tarjeta' || tipoPago == ''
                          ? false
                          : true,
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Entregado 10 €'),
                            Text('Cambio 1.50 €')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget containerColumna(double sizeWidth, String content) {
    return SizedBox(
        width: sizeWidth / 3.25,
        child: Text(
          content,
          textAlign: TextAlign.center,
        ));
  }
}
