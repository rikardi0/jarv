import 'package:flutter/material.dart';
import 'package:jarv/src/data_source/db.dart';
import 'package:jarv/src/utils/models/producto_ordenado.dart';

class TicketDiario extends StatefulWidget {
  const TicketDiario({super.key, required this.ventas});
  static const routeName = '/ticket_diario';
  final VentaDao ventas;

  @override
  State<TicketDiario> createState() => _TicketDiarioState();
}

class _TicketDiarioState extends State<TicketDiario> {
  final selectedVenta = ValueNotifier<int?>(null);
  final List<ProductoOrdenado> listaVenta = [];
  @override
  Widget build(BuildContext context) {
    final venta = widget.ventas.findAllVentas();

    return Scaffold(
        body: FutureBuilder(
      future: venta,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const Row(
            children: [],
          );
        } else {
          return const Center(child: Text('NO DATA'));
        }
      },
    ));
  }
}
