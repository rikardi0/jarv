import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jarv/src/data_source/db.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sqflite/sqflite.dart';

class TicketDiario extends StatefulWidget {
  const TicketDiario({
    super.key,
    required this.ventas,
    required this.ventaDetalle,
    required this.producto,
    required this.databaseExecutor,
  });
  static const routeName = '/ticket_diario';
  final VentaDao ventas;
  final DetalleVentaDao ventaDetalle;
  final ProductoDao producto;
  final DatabaseExecutor databaseExecutor;

  @override
  State<TicketDiario> createState() => _TicketDiarioState();
}

class _TicketDiarioState extends State<TicketDiario> {
  List<Map<String, Object?>> listaProducto = [];
  String fechaFactura = '';
  String horaFactura = '';
  double montoFactura = 0.0;
  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  Future<void> _loadDataFromDatabase() async {
    try {
      final data = await widget.databaseExecutor.rawQuery('''
SELECT Producto.*, Producto.iva, DetalleVenta.cantidad
FROM DetalleVenta
INNER JOIN Producto ON Producto.productoId = DetalleVenta.productoId
WHERE DetalleVenta.idVenta = ?
''', [ventaSeleccionada]);
      setState(() {
        listaProducto = data;
      });
    } catch (e) {
      print('Error loading data from database: $e');
    }
  }

  final selectedVenta = ValueNotifier<int?>(null);
  int ventaSeleccionada = 0;
  List<int> idProductosVenta = [];
  @override
  Widget build(BuildContext context) {
    final dateTime = DateTime.now();
    final fechaHoy = '${dateTime.day}/${dateTime.month}/${dateTime.year}';

    final ventaDiaria = widget.ventas.findVentaByFecha(fechaHoy).asStream();

    final selectedVenta = ValueNotifier<int?>(null);

    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder2(
          streams:
              StreamTuple2(ventaDiaria, _loadDataFromDatabase().asStream()),
          builder: (context, snapshot) {
            if (!snapshot.snapshot1.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              final ventaItem = snapshot.snapshot1.data;

              return Row(
                children: [
                  _tarjetaVenta(context, ventaItem),
                  _containerFactura(context)
                ],
              );
            }
          },
        ));
  }

  Widget _containerFactura(BuildContext context) {
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
                    Expanded(
                      child: SizedBox(
                        child: _columnProducto(),
                      ),
                    ),
                    const Divider(),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Impuesto'), Text('Base'), Text('Cuota')],
                    ),
                    Expanded(
                      child: _columnImpuesto(),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total'),
                          Text('$montoFactura €')
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView _columnImpuesto() {
    return ListView.builder(
      itemCount: listaProducto.length,
      itemBuilder: (context, index) {
        final impuesto = double.parse(listaProducto[index]['iva'].toString());
        final precioUnitario = listaProducto[index]['precio'].toString();
        final cantidad = listaProducto[index]['cantidad'].toString();
        final precioTotal = double.parse(precioUnitario) * int.parse(cantidad);
        final base = precioTotal * impuesto;
        final precio = precioTotal + base;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('${(impuesto * 100).toInt().toString()}%'),
              ],
            ),
            Text(base.toString()),
            Text(precio.toString()),
          ],
        );
      },
    );
  }

  ListView _columnProducto() {
    return ListView.builder(
      itemCount: listaProducto.length,
      itemBuilder: (context, index) {
        final nombreProducto = listaProducto[index]['producto'].toString();
        final precioUnitario = listaProducto[index]['precio'].toString();
        final cantidad = listaProducto[index]['cantidad'].toString();

        final precioTotal = double.parse(precioUnitario) * int.parse(cantidad);
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(nombreProducto),
                  Text('$cantidad x $precioUnitario'),
                ],
              ),
            ),
            Text(precioTotal.toString())
          ],
        );
      },
    );
  }

  Expanded _tarjetaVenta(BuildContext context, List<Venta?>? ventaItem) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
          itemCount: ventaItem!.length,
          itemBuilder: (context, index) {
            final venta = ventaItem[index];
            final dateTime =
                DateTime.fromMillisecondsSinceEpoch(venta!.idVenta);
            final String hora =
                '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
            return Card(
              color: selectedVenta.value != index
                  ? Theme.of(context).cardTheme.color
                  : Colors.transparent,
              elevation: selectedVenta.value != index
                  ? Theme.of(context).cardTheme.elevation
                  : 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(
                    color: selectedVenta.value == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent),
              ),
              child: ListTile(
                selected: selectedVenta.value == index ? true : false,
                selectedColor: Theme.of(context).colorScheme.primary,
                onTap: () {
                  setState(() {
                    if (selectedVenta.value != index) {
                      selectedVenta.value = index;
                    } else {
                      selectedVenta.value = null;
                    }
                    ventaSeleccionada = venta.idVenta;
                    fechaFactura = venta.fecha;
                    montoFactura = venta.costeTotal;
                    horaFactura = hora;
                    _loadDataFromDatabase();
                  });
                },
                title: Text('Total'),
                subtitle: Text(venta!.costeTotal.floorToDouble().toString()),
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(venta.fecha),
                    Text(hora.toString()),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
