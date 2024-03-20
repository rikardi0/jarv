import 'package:flutter/material.dart';
import 'package:jarv/shared/ui/cliente_selector.dart';
import 'package:jarv/shared/ui/metodo_pago_selector.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/data-sources/dao_venta.dart';
import '../../data/model/entity_venta.dart';

class TicketDiario extends StatefulWidget {
  const TicketDiario({
    super.key,
    required this.ventas,
    required this.ventaDetalle,
    required this.cliente,
    required this.producto,
    required this.databaseExecutor,
  });
  static const routeName = '/ticket_diario';
  final VentaDao ventas;
  final DetalleVentaDao ventaDetalle;
  final ClienteDao cliente;
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
  bool intervalo = false;
  String cliente = 'nombreCliente 1';
  String metodoPago = 'tarjeta';

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
      // ignore: avoid_print
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
    final clienteLista = widget.cliente.findAllClienteNombre();

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
                  _containerFactura(context),
                  _filtroVenta(context, clienteLista),
                ],
              );
            }
          },
        ));
  }

  Padding _filtroVenta(
      BuildContext context, Stream<List<String>> clienteLista) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: Expanded(
        child: Container(
          decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceVariant
                  .withOpacity(0.25),
              borderRadius: BorderRadius.circular(10)),
          width: MediaQuery.of(context).size.width * 0.3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DatePicker(
                  intervalo: intervalo,
                  onChanged: (value) {
                    setState(() {
                      intervalo = value;
                    });
                  },
                ),
                ClienteSelector(
                    cliente: cliente,
                    clienteLista: clienteLista,
                    onChanged: (value) {
                      setState(() {
                        cliente = value;
                      });
                    }),
                MetodoPagoSelector(
                    metodoPago: metodoPago,
                    onChanged: (value) {
                      setState(() {
                        metodoPago = value;
                      });
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _containerFactura(BuildContext context) {
    return Visibility(
      visible: selectedVenta.value != null ? true : false,
      child: Padding(
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
              width: MediaQuery.of(context).size.width * 0.35,
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
                        children: [
                          Text('Impuesto'),
                          Text('Base'),
                          Text('Cuota')
                        ],
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
                visualDensity: VisualDensity.compact,
                isThreeLine: true,
                titleAlignment: ListTileTitleAlignment.center,
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
                title: const Text('Total'),
                subtitle: Text(venta.costeTotal.floorToDouble().toString()),
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

class DatePicker extends StatelessWidget {
  const DatePicker({
    super.key,
    required this.intervalo,
    required this.onChanged,
  });

  final bool intervalo;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          readOnly: true,
          onTap: () {
            if (intervalo) {
              showDateRangePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now());
            } else {
              showDatePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now());
            }
          },
          decoration: InputDecoration(
            helperText: intervalo ? 'dd/mm/aaaa - dd/mm/aaaa' : 'dd/mm/aaaa',
            labelText: 'Fecha',
            suffixIcon: const Icon(Icons.calendar_month),
          ),
        ),
        Row(
          children: [
            Switch(
                value: intervalo,
                onChanged: (value) {
                  onChanged(value);
                }),
            Text(
              'Intervalo',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        )
      ],
    );
  }
}