import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/producto_ordenado.dart';

class FacturaFiscal extends StatelessWidget {
  const FacturaFiscal({
    super.key,
    required this.listaProducto,
    required this.impuesto,
    required this.tipoPago,
    required this.precioVenta,
  });

  final List<ProductoOrdenado?> listaProducto;
  final double impuesto;
  final double? precioVenta;
  final String tipoPago;

  @override
  Widget build(BuildContext context) {
    final impuestoProducto = precioVenta! * impuesto;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.15))),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.375,
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    const Text('TITULO EMPRESA'),
                    const Text('RIF'),
                    const Text('UBICACION'),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(tipoPago == ''
                            ? 'Venta en Espera'
                            : 'Venta $tipoPago'),
                        const Text('16/02/2024'),
                        const Text('12:15 pm')
                      ],
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Impu'), Text('Base'), Text('Cuotas')],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${(impuesto * 100).floor().toString()} %'),
                        Text(impuestoProducto.toString()),
                        Text((precioVenta! + impuestoProducto).toString())
                      ],
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Total'), Text('8.5 €')],
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
}
