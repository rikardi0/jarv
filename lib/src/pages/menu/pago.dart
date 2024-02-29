import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';
import 'package:flutter/services.dart';

class Pago extends StatefulWidget {
  const Pago({super.key});

  static const routeName = "/venta";

  @override
  State<Pago> createState() => _PagoState();
}

class _PagoState extends State<Pago> {
  String metodoPago = 'tarjeta';
  int entregado = 0;
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
            SizedBox(
              width: size.width * 0.35,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: _columnMetodoPago(context, argument),
              ),
            ),
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

  Widget _columnMetodoPago(BuildContext context, CheckOutArgument argument) {
    final cambio = entregado - argument.totalVenta;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Venta',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Text(
            'Metodo de Pago',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _dropDownMetodoPago(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total :'),
              Text(argument.totalVenta.toString()),
            ],
          ),
        ),
        rowColumn(
            'Entregado',
            SizedBox(
              width: 50,
              child: TextField(
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  FilteringTextInputFormatter.digitsOnly
                ],
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    entregado = int.parse(value);
                  } else {
                    entregado = 0;
                  }
                  setState(() {});
                },
              ),
            )),
        const Divider(),
        rowColumn(
            'Cambio',
            Text(entregado == 0
                ? 'SIN CAMBIO'
                : cambio.isNegative
                    ? 'Faltan ${cambio.abs().toString()}'
                    : cambio.toString())),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () {}, child: const Text('Imprimir Ticket')),
            ElevatedButton(onPressed: () {}, child: const Text('Sin Ticket')),
          ],
        ),
      ],
    );
  }

  Widget rowColumn(String title, Widget content) {
    return Visibility(
      visible: metodoPago == 'tarjeta' ? false : true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$title :'),
            content,
          ],
        ),
      ),
    );
  }

  DropdownButton<dynamic> _dropDownMetodoPago() {
    return DropdownButton(
        isExpanded: true,
        icon: Icon(
            metodoPago == 'tarjeta' ? Icons.payment : Icons.payments_outlined),
        value: metodoPago,
        items: const <DropdownMenuItem>[
          DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
          DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
        ],
        onChanged: (value) {
          metodoPago = value;
          setState(() {});
        });
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
                Visibility(
                  visible: tipoPago == 'tarjeta' ? false : true,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Entregado 10 €'), Text('Cambio 1.50 €')],
                    ),
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
