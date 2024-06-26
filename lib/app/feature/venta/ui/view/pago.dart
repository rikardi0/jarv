import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jarv/app/feature/venta/data/model/arguments_check_out.dart';
import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/pago_repository.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/utils/date_format.dart';
import 'package:jarv/shared/ui/widget/cliente_selector.dart';
import 'package:jarv/shared/ui/widget/factura_fiscal.dart';
import 'package:jarv/shared/ui/widget/metodo_pago_selector.dart';

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
  String? metodoPago;

  String? cliente;
  double totalFactura = 0;
  int efectivoEntregado = 0;
  double cambio = 0;

  final _metodoPagoField = GlobalKey<FormState>();
  final _clienteField = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final CheckOutArgument argument =
        ModalRoute.of(context)!.settings.arguments as CheckOutArgument;
    final size = MediaQuery.of(context).size;

    totalFactura = argument.productoAgregado.fold(
      0.0,
      (previousValue, element) =>
          previousValue +
          (element!.precio) * double.parse(element.cantidad) * (1),
    );

    return Scaffold(
        appBar: AppBar(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: size.width * 0.35,
                  child: Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: _columnMetodoPago(context, argument),
                  ),
                ),
              ),
            ),
            FacturaFiscal(
              listaProducto: argument.productoAgregado,
              metodoPago: metodoPago,
              precioVenta: argument.totalVenta,
              efectivoEntregado: efectivoEntregado,
              cambio: cambio,
            ),
          ],
        ));
  }

  Widget _columnMetodoPago(
    BuildContext context,
    CheckOutArgument argument,
  ) {
    cambio = efectivoEntregado - argument.totalVenta;
    final clienteLista = widget.fecthRepository.findAllClienteNombre();

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Venta',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Form(
            key: _metodoPagoField,
            child: MetodoPagoSelector(
                metodoPago: metodoPago,
                onCancel: () {
                  setState(() {
                    metodoPago = null;
                  });
                },
                onChanged: (value) {
                  metodoPago = value;
                  setState(() {});
                }),
          ),
          Form(
            key: _clienteField,
            child: ClienteSelector(
              cliente: cliente,
              clienteLista: clienteLista,
              onChanged: (value) {
                cliente = value;
                setState(() {});
              },
            ),
          ),
          _totalFactura(),
          _efectivoEntregado(),
          _cambioEntregar(cambio),
          _registrarButton(argument),
        ],
      ),
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
      visible: metodoPago == 'tarjeta' || metodoPago == null ? false : true,
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
              if (_metodoPagoField.currentState!.validate()) {
                _registrarVenta(argument, false);
                Navigator.pushNamed(context, '/menu');
              }
            },
            child: const Text('No Imprimir')),
        FilledButton(
            onPressed: () {
              if (_metodoPagoField.currentState!.validate() &&
                  _clienteField.currentState!.validate()) {
                _registrarVenta(argument, true);
                Navigator.pushNamed(context, '/menu');
              }
            },
            child: const Text('Imprimir Ticket')),
      ],
    );
  }

  void _registrarVenta(CheckOutArgument argument, bool imprimirTicker) async {
    final idVenta = DateTime.now().millisecondsSinceEpoch;
    final fechaFormatoVenta = fechaFormatter(argument.fechaVenta);
    final tipoVenta = await widget.fecthRepository.findTipoVentaById(0);

    for (var element in argument.productoAgregado) {
      widget.fecthRepository.insertDetalleVenta(DetalleVenta(
          productoId: element!.productoId,
          cantidad: int.parse(element.cantidad),
          precioUnitario: element.precio,
          descuento: 0,
          idDetalleVenta: UniqueKey().toString(),
          idVenta: idVenta,
          entregado: true));
    }

    widget.fecthRepository.insertVenta(Venta(
        idVenta: idVenta,
        costeTotal: totalFactura,
        ingresoTotal: argument.totalVenta,
        fecha: fechaFormatoVenta,
        idUsuario: 01,
        nombreCliente: imprimirTicker ? cliente! : 'Sin Nombre Cliente',
        metodoPago: metodoPago!,
        tipoVenta: tipoVenta!));
  }
}
