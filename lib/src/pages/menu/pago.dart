import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';

class Pago extends StatefulWidget {
  const Pago({super.key});

  static const routeName = "/venta";

  @override
  State<Pago> createState() => _PagoState();
}

class _PagoState extends State<Pago> {
  String metodoPago = 'tarjeta';
  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromARGB(59, 7, 7, 7);
    final CheckOutArgument argument =
        ModalRoute.of(context)!.settings.arguments as CheckOutArgument;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 170, 117, 255),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _columnVenta(context),
            FacturaFiscal(
              size: size,
              borderColor: borderColor,
              listaProducto: argument.productoAgregado,
              impuesto: 0.1,
              tipoPago: metodoPago,
              precioVenta: argument.totalVenta,
            ),
          ],
        ));
  }

  Padding _columnVenta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Venta',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              'Metodo de Pago',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          DropdownButton(
              isExpanded: true,
              icon: Icon(metodoPago == 'tarjeta'
                  ? Icons.payment
                  : Icons.payments_outlined),
              value: metodoPago,
              items: const <DropdownMenuItem>[
                DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
                DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
              ],
              onChanged: (value) {
                metodoPago = value;
                setState(() {});
              })
        ],
      ),
    );
  }
}

class FacturaFiscal extends StatelessWidget {
  const FacturaFiscal({
    super.key,
    required this.size,
    required this.borderColor,
    required this.listaProducto,
    required this.impuesto,
    required this.tipoPago,
    required this.precioVenta,
  });

  final Size size;
  final Color borderColor;
  final List<ProductoPreOrdenado?> listaProducto;
  final double impuesto;
  final double precioVenta;
  final String tipoPago;

  @override
  Widget build(BuildContext context) {
    final impuestoProducto = precioVenta * impuesto;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width * 0.5,
        child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 254),
              border: Border.all(color: borderColor)),
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
                    Text('Venta $tipoPago'),
                    const Text('16/02/2024'),
                    const Text('12:15 pm')
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: listaProducto.length,
                    itemBuilder: (BuildContext context, int index) {
                      final productoOrdenado = listaProducto[index];

                      final precio = double.parse(productoOrdenado!.cantidad) *
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
                    Text((precioVenta + impuestoProducto).toString())
                  ],
                ),
                const Divider(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text('Total'), Text('8.5 €')],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Entregado 10 €'), Text('Cambio 1.50 €')],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
