import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/ticket_diario_repository.dart';
import 'package:jarv/app/feature/venta/ui/utils/date_format.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/metodo_pago_selector.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import '../../data/model/entity_venta.dart';

class TicketDiario extends StatefulWidget {
  TicketDiario({
    super.key,
  });
  static const routeName = '/ticket_diario';
  final fecthRepository = localService<TicketDiarioRepository>();

  @override
  State<TicketDiario> createState() => _TicketDiarioState();
}

class _TicketDiarioState extends State<TicketDiario> {
  List<Map<String, Object?>> listaProducto = [];
  TextEditingController fechaTextController = TextEditingController();
  String fechaFactura = '';
  String horaFactura = '';

  String? cliente;
  String? metodoPago;

  List<Venta?>? listaVenta;
  bool isRangeActive = false;
  int ventaSeleccionada = 0;
  double montoFactura = 0.0;

  DateTimeRange rangoFechaFiltro =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTime fechaActual = DateTime.now();

  final selectedVenta = ValueNotifier<int?>(null);

  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  Future<void> _loadDataFromDatabase() async {
    try {
      final data = await widget.fecthRepository
          .findProductoByVentaId([ventaSeleccionada]);
      setState(() {
        listaProducto = data;
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error loading data from database: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final fechaFormateada = fechaFormatter(fechaActual);

    final ventaDiaria =
        widget.fecthRepository.findVentaByFecha(fechaFormateada).asStream();
    final List<String> clienteLista = [];

    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder2(
          streams:
              StreamTuple2(ventaDiaria, _loadDataFromDatabase().asStream()),
          builder: (context, snapshot) {
            if (!snapshot.snapshot1.hasData) {
              return const Center(child: CircularProgressIndicator());
            } else {
              listaVenta = snapshot.snapshot1.data;
              final itemVenta = snapshot.snapshot1.data;
              if (cliente != null) {
                listaVenta = listaVenta!.where((element) {
                  return element!.nombreCliente
                      .toString()
                      .toLowerCase()
                      .contains(cliente!.toLowerCase());
                }).toList();
              } else if (metodoPago != null) {
                listaVenta = listaVenta!.where((element) {
                  return element!.metodoPago
                      .toString()
                      .toLowerCase()
                      .contains(metodoPago!.toLowerCase());
                }).toList();
              }
              for (var element in itemVenta!) {
                if (!clienteLista.contains(element!.nombreCliente)) {
                  clienteLista.add(element.nombreCliente);
                }
              }
              return Row(
                children: [
                  _tarjetaVenta(context, listaVenta),
                  _containerFactura(context),
                  _filtroVenta(context, clienteLista),
                ],
              );
            }
          },
        ));
  }

  Padding _filtroVenta(BuildContext context, List<String> clienteLista) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.3,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDatePciker(context),
              _buildCliente(clienteLista),
              MetodoPagoSelector(
                  metodoPago: metodoPago,
                  onCancel: () {
                    setState(() {
                      metodoPago = null;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      metodoPago = value;
                      cliente = null;
                    });
                  }),
              FilledButton(onPressed: () {}, child: const Text('Imprimir'))
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _buildCliente(List<String> clienteLista) {
    return DropdownButtonFormField<String>(
      value: cliente,
      hint: const Text('Cliente'),
      isExpanded: true,
      icon: cliente != null
          ? GestureDetector(
              onTap: () {
                cliente = null;
                setState(() {});
              },
              child: const Icon(Icons.cancel_outlined),
            )
          : const Icon(Icons.arrow_drop_down),
      items: clienteLista.map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          metodoPago = null;
          cliente = value;
        });
      },
    );
  }

  Column _buildDatePciker(BuildContext context) {
    String fechaValue = fechaFormatter(fechaActual);
    String fechaRangeHint =
        '${fechaFormatter(rangoFechaFiltro.start)} - ${fechaFormatter(rangoFechaFiltro.end)}';

    return Column(
      children: [
        TextFormField(
          readOnly: true,
          controller: fechaTextController,
          onTap: () async {
            setState(() {
              metodoPago = null;
              cliente = null;
            });
            if (isRangeActive) {
              final rangoSeleccionado = await showDateRangePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now());
              fechaTextController.text = fechaRangeHint;
              fechaTextController.text = fechaRangeHint;
              if (rangoSeleccionado != null) {
                setState(() {
                  rangoFechaFiltro = rangoSeleccionado;
                });
              }
            } else {
              final fechaSeleccionada = await showDatePicker(
                  context: context,
                  initialEntryMode: DatePickerEntryMode.calendarOnly,
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now());
              fechaTextController.text = fechaValue;
              if (fechaSeleccionada != null) {
                setState(() {
                  fechaActual = fechaSeleccionada;
                });
              }
            }
          },
          decoration: InputDecoration(
            helperText:
                isRangeActive ? 'dd/mm/aaaa - dd/mm/aaaa' : 'dd/mm/aaaa',
            labelText: 'Fecha',
            suffixIcon: const Icon(Icons.calendar_month),
          ),
        ),
        Row(
          children: [
            Switch(
                value: isRangeActive,
                onChanged: (value) {
                  setState(() {
                    fechaTextController.text = '';
                    isRangeActive = value;
                    fechaActual = DateTime.now();
                    rangoFechaFiltro = DateTimeRange(
                        start: DateTime.now(), end: DateTime.now());
                  });
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
            final String hora = hourFormatter(dateTime);
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
                    montoFactura = venta.costeTotal.floorToDouble();
                    horaFactura = hora;
                    _loadDataFromDatabase();
                  });
                },
                title: Text(venta.nombreCliente),
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
