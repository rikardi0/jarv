import 'package:flutter/material.dart';
import 'package:jarv/src/data_source/db.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:flutter/services.dart';

import '../../widgets/cliente_selector.dart';
import '../../widgets/factura_fiscal.dart';
import '../../widgets/metodo_pago_selector.dart';

class Pago extends StatefulWidget {
  const Pago(
      {super.key,
      required this.venta,
      required this.cliente,
      required this.detalleVenta});

  static const routeName = "/venta";
  final VentaDao venta;
  final DetalleVentaDao detalleVenta;
  final ClienteDao cliente;

  @override
  State<Pago> createState() => _PagoState();
}

class _PagoState extends State<Pago> {
  String metodoPago = 'tarjeta';
  String cliente = 'nombreCliente 1';
  double totalFactura = 0;
  int entregado = 0;

  @override
  Widget build(BuildContext context) {
    final CheckOutArgument argument =
        ModalRoute.of(context)!.settings.arguments as CheckOutArgument;
    final size = MediaQuery.of(context).size;

    totalFactura = argument.productoAgregado.fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          (element!.precio) *
              double.parse(element.cantidad) *
              (1 + (element.iva)),
    );

    return Scaffold(
        appBar: AppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
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
              tipoPago: metodoPago,
              precioVenta: argument.totalVenta,
            ),
          ],
        ));
  }

  Widget _columnMetodoPago(BuildContext context, CheckOutArgument argument) {
    final cambio = entregado - argument.totalVenta;
    final Stream<List<String>> clienteLista =
        widget.cliente.findAllClienteNombre();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Venta',
          style: Theme.of(context).textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        MetodoPagoSelector(
            metodoPago: metodoPago,
            onChanged: (value) {
              metodoPago = value;
              setState(() {});
            }),
        ClienteSelector(
          cliente: cliente,
          clienteLista: clienteLista,
          onChanged: (value) {
            cliente = value;
            setState(() {});
          },
        ),
        _totalFactura(),
        _efectivoEntregado(),
        _cambioEntregar(cambio),
        _registrarButton(argument),
      ],
    );
  }

  Padding _totalFactura() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total :'),
          Text(totalFactura.floorToDouble().toString()),
        ],
      ),
    );
  }

  Widget _efectivoEntregado() {
    return rowColumn(
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
        ));
  }

  Widget _cambioEntregar(double cambio) {
    return rowColumn(
        'Cambio',
        Text(entregado == 0
            ? 'SIN CAMBIO'
            : cambio.isNegative
                ? 'Faltan ${cambio.abs().toString()}'
                : cambio.toString()));
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

  Row _registrarButton(CheckOutArgument argument) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
            onPressed: () {
              _registrarVenta(argument);
            },
            child: const Text('No Imprimir')),
        FilledButton(
            onPressed: () {
              _registrarVenta(argument);
            },
            child: const Text('Imprimir Ticket')),
      ],
    );
  }

  void _registrarVenta(CheckOutArgument argument) {
    final idVenta = DateTime.now().millisecondsSinceEpoch;

    for (var element in argument.productoAgregado) {
      widget.detalleVenta.insertDetalleVenta(DetalleVenta(
          idVenta,
          element!.productoId,
          int.parse(element.cantidad),
          element.precio,
          0,
          true,
          UniqueKey().toString()));
    }
    final fechaMes =
        '${argument.fechaVenta.day}/${argument.fechaVenta.month}/${argument.fechaVenta.year}';

    widget.venta.insertVenta(Venta(
        idVenta: idVenta,
        costeTotal: totalFactura,
        ingresoTotal: argument.totalVenta,
        fecha: fechaMes,
        idUsuario: 01,
        nombreCliente: cliente,
        consumicionPropia: false,
        metodoPago: metodoPago));

    Navigator.pushNamed(context, '/menu');
  }
}
