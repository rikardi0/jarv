import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/data/model/arguments_check_out.dart';
import 'package:flutter/services.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/pago_repository.dart';
import 'package:jarv/core/di/locator.dart';

import '../../../../../shared/ui/cliente_selector.dart';
import '../../../../../shared/ui/factura_fiscal.dart';
import '../../../../../shared/ui/metodo_pago_selector.dart';
import '../../data/model/entity_venta.dart';

class Pago extends StatefulWidget {
  Pago({
    super.key,
  });

  static const routeName = "/venta";
  final fecthRepository = localService<PagoRepository>();

  @override
  State<Pago> createState() => _PagoState();
}

class _PagoState extends State<Pago> {
  String metodoPago = 'tarjeta';
  String cliente = 'nombreCliente 1';
  double totalFactura = 0;
  int efectivoEntregado = 0;

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
    final cambio = efectivoEntregado - argument.totalVenta;
    final clienteLista = widget.fecthRepository.findAllClienteNombre();

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
                efectivoEntregado = int.parse(value);
              } else {
                efectivoEntregado = 0;
              }
              setState(() {});
            },
          ),
        ));
  }

  Widget _cambioEntregar(double cambio) {
    return rowColumn(
        'Cambio',
        Text(efectivoEntregado == 0
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
    final fechaFormatoVenta =
        '${argument.fechaVenta.day}/${argument.fechaVenta.month}/${argument.fechaVenta.year}';

    for (var element in argument.productoAgregado) {
      widget.fecthRepository.insertDetalleVenta(DetalleVenta(
          idVenta,
          element!.productoId,
          int.parse(element.cantidad),
          element.precio,
          0,
          true,
          UniqueKey().toString()));
    }

    widget.fecthRepository.insertVenta(Venta(
        idVenta: idVenta,
        costeTotal: totalFactura,
        ingresoTotal: argument.totalVenta,
        fecha: fechaFormatoVenta,
        idUsuario: 01,
        nombreCliente: cliente,
        consumicionPropia: false,
        metodoPago: metodoPago));

    Navigator.pushNamed(context, '/menu');
  }
}
