import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:flutter/services.dart';

import '../../widgets/factura_fiscal.dart';

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
    final CheckOutArgument argument =
        ModalRoute.of(context)!.settings.arguments as CheckOutArgument;
    final size = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(),
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
            ElevatedButton(onPressed: () {}, child: const Text('No Imprimir')),
            FilledButton(
                onPressed: () {}, child: const Text('Imprimir Ticket')),
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
