import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/ticket_diario_repository.dart';
import 'package:jarv/app/feature/venta/ui/utils/date_format.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/empty_message.dart';
import 'package:jarv/shared/ui/metodo_pago_selector.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class TicketDiario extends StatefulWidget {
  TicketDiario({
    super.key,
  });

  static const routeName = '/ticket_diario';
  final TicketDiarioRepository fetchRepository =
      localService<TicketDiarioRepository>();

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
  String? tipoVenta;

  List<Venta?>? listaVenta;
  List<TipoVenta?>? tipoVentaLista;
  bool isRangeActive = false;
  int ventaSeleccionada = 0;
  double montoFactura = 0.0;

  DateTimeRange rangoFechaFiltro =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());
  DateTime fechaActual = DateTime.now();
  late List<Map<String, Object?>> data;
  final selectedVenta = ValueNotifier<int?>(0);

  @override
  void initState() {
    super.initState();
    _loadDataFromDatabase();
  }

  Future<void> _loadDataFromDatabase() async {
    try {
      List<Map<String, Object?>> data = await widget.fetchRepository
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
        widget.fetchRepository.findVentaByFecha(fechaFormateada);

    Future<void> inicializarDatos() async {
      if (ventaSeleccionada == 0) {
        List<Venta?> venta = await ventaDiaria;
        ventaSeleccionada = venta.reversed.toList().first!.idVenta;

        data = await widget.fetchRepository
            .findProductoByVentaId([ventaSeleccionada]);
        montoFactura = venta.reversed.toList().first!.costeTotal;
      }
    }

    final List<String> clienteLista = [];

    return FutureBuilder(
        future: inicializarDatos(),
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Ticket Diario'),
              ),
              body: StreamBuilder3(
                streams: StreamTuple3(
                    ventaDiaria.asStream(),
                    _loadDataFromDatabase().asStream(),
                    widget.fetchRepository.findAllTipoVenta().asStream()),
                builder: (context, snapshot) {
                  if (!snapshot.snapshot1.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final itemVenta = snapshot.snapshot1.data;
                    listaVenta = snapshot.snapshot1.data;
                    tipoVentaLista = snapshot.snapshot3.data;
                    _filtrarCriterios();
                    for (var element in itemVenta!) {
                      if (!clienteLista.contains(element!.nombreCliente)) {
                        clienteLista.add(element.nombreCliente);
                      }
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          listaVenta!.isEmpty
                              ? const EmptyMessage()
                              : _tarjetaVenta(context, listaVenta),
                          Visibility(
                              visible: listaVenta!.isEmpty ? false : true,
                              child: _containerFactura(context)),
                          _filtroVenta(context, clienteLista, tipoVentaLista),
                        ],
                      ),
                    );
                  }
                },
              ));
        });
  }

  void _filtrarCriterios() {
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
    } else if (tipoVenta != null) {
      listaVenta = listaVenta!.where((element) {
        return element!.tipoVenta
            .toString()
            .toLowerCase()
            .contains(tipoVenta!.toLowerCase());
      }).toList();
    }
  }

  Padding _filtroVenta(
      BuildContext context, List<String> clienteLista, tipoVentaLista) {
    final List<String> lista = [];
    if (tipoVentaLista != null) {
      for (var element in tipoVentaLista) {
        lista.add(element!.tipoVenta);
      }
    }
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 5.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        height: MediaQuery.of(context).size.height * 0.65,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.5),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDatePicker(context),
              _buildClienteDropDown(clienteLista),
              _buildTipoVentaDropDown(lista),
              MetodoPagoSelector(
                  metodoPago: metodoPago,
                  onCancel: () {
                    setState(() {
                      metodoPago = null;
                      selectedVenta.value = null;
                    });
                  },
                  onChanged: (value) {
                    setState(() {
                      metodoPago = value;
                      cliente = null;
                      tipoVenta = null;
                      selectedVenta.value = null;
                    });
                  }),
              FilledButton(onPressed: () {}, child: const Text('Imprimir'))
            ],
          ),
        ),
      ),
    );
  }

  DropdownButtonFormField<String> _buildClienteDropDown(
      List<String> clienteLista) {
    return DropdownButtonFormField<String>(
      value: cliente,
      hint: const Text('Cliente'),
      isExpanded: true,
      icon: cliente != null
          ? GestureDetector(
              onTap: () {
                cliente = null;
                selectedVenta.value = null;
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
          selectedVenta.value = null;
          metodoPago = null;
          tipoVenta = null;
          cliente = value;
        });
      },
    );
  }

  DropdownButtonFormField<String> _buildTipoVentaDropDown(
      List<String> tipoVentaLista) {
    return DropdownButtonFormField<String>(
      value: tipoVenta,
      hint: const Text('Tipo Venta'),
      isExpanded: true,
      icon: tipoVenta != null
          ? GestureDetector(
              onTap: () {
                tipoVenta = null;
                selectedVenta.value = null;
                setState(() {});
              },
              child: const Icon(Icons.cancel_outlined),
            )
          : const Icon(Icons.arrow_drop_down),
      items: tipoVentaLista.map((String value) {
        return DropdownMenuItem(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedVenta.value = null;
          metodoPago = null;
          cliente = null;
          tipoVenta = value;
        });
      },
    );
  }

  Column _buildDatePicker(BuildContext context) {
    String fechaValue = fechaFormatter(fechaActual);
    String fechaRangeHint =
        '${fechaFormatter(rangoFechaFiltro.start)} - ${fechaFormatter(rangoFechaFiltro.end)}';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0),
          child: TextFormField(
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
                    selectedVenta.value = null;
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
    final double sizeWidth = MediaQuery.of(context).size.width * 0.35;
    return Visibility(
      visible: selectedVenta.value != null ? true : false,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onBackground
                      .withOpacity(0.15))),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SizedBox(
              width: sizeWidth,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          containerColumna(sizeWidth, 'Impuesto'),
                          containerColumna(sizeWidth, 'Base'),
                          containerColumna(sizeWidth, 'Cuota')
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
        final double sizeWidth = MediaQuery.of(context).size.width * 0.35;
        final impuesto = double.parse(listaProducto[index]['iva'].toString());
        final precioUnitario = listaProducto[index]['precio'].toString();
        final cantidad = listaProducto[index]['cantidad'].toString();
        final precioTotal = double.parse(precioUnitario) * int.parse(cantidad);
        final base = precioTotal * impuesto;
        final precio = precioTotal - base;

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            containerColumna(
                sizeWidth, '${(impuesto * 100).toInt().toString()}%'),
            containerColumna(sizeWidth, base.toString()),
            containerColumna(sizeWidth, precio.toString()),
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

  Widget _tarjetaVenta(BuildContext context, List<Venta?>? ventaItem) {
    return Expanded(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: ListView.builder(
            itemCount: ventaItem!.length,
            itemBuilder: (context, index) {
              final venta = ventaItem.reversed.toList()[index];
              final dateTime =
                  DateTime.fromMillisecondsSinceEpoch(venta!.idVenta);
              final String hora = hourFormatter(dateTime);

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
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
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget containerColumna(double sizeWidth, String content) {
    return SizedBox(
        width: sizeWidth / 3.25,
        child: Text(
          content,
          textAlign: TextAlign.center,
        ));
  }
}
