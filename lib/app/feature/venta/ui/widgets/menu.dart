import 'package:jarv/app/feature/proveedor/ui/view/proveedor_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

import 'package:jarv/app/feature/venta/data/model/arguments_check_out.dart';
import 'package:jarv/app/feature/venta/data/model/producto_ordenado.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/pago_repository.dart';
import '../../../../../shared/data/model/entity.dart';
import '../../data/repositories/interfaces/menu_repository.dart';
import '../../data/model/entity_venta.dart';
import 'package:jarv/core/di/locator.dart';

import 'package:jarv/app/feature/venta/ui/provider/venta_espera_provider.dart';
import 'package:jarv/app/feature/venta/ui/utils/date_format.dart';

import 'package:jarv/shared/ui/widgets.dart';

class Menu extends StatefulWidget {
  const Menu(
    this.devolucion, {
    super.key,
    required this.menuPrincipal,
    required this.titleSection,
  });

  final bool menuPrincipal;
  final bool devolucion;
  final String titleSection;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  String familiaSeleccionada = "";
  String subFamiliaSeleccionada = "";
  String cantidadProducto = '';
  String? tipoDevolucion;

  String? identificadorVenta;

  bool mostrarUsuario = true;
  bool mostrarTeclado = true;
  bool mostrarIdentificador = false;

  List<String> cantidad = [];
  List<ProductoOrdenado?> productosAgregados = [];

  double totalVenta = 0;
  double totalVentaEspera = 0;

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);
  final selectedItemLista = ValueNotifier<int?>(null);

  @override
  void initState() {
    if (widget.menuPrincipal) {
      super.initState();
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _changeState();
      });
    }
  }

  _changeState() async {
    final VentaEsperaProvider provider =
        Provider.of<VentaEsperaProvider>(context, listen: false);
    bool? showElementoEspera = provider.mostrarElementoEspera;
    int? posicionElementoEspera = provider.posicionListaEspera;

    if (showElementoEspera!) {
      productosAgregados =
          provider.listaEspera[posicionElementoEspera!].listaProducto;

      totalVenta += provider.listaEspera[posicionElementoEspera].totalVenta!;
      provider.deleteProductoEspera(index: posicionElementoEspera);
      context.read<VentaEsperaProvider>().changeBool(productoEspera: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MenuRepository fecthMenuRepository =
        localService.get<MenuRepository>();

    const borderColor = Color.fromARGB(59, 7, 7, 7);

    final String joinedCantidad =
        cantidad.map((value) => int.parse(value)).toList().join();

    final listaFamilia = fecthMenuRepository.findAllFamilias();
    final listaSubFamilia =
        fecthMenuRepository.findSubFamiliaByFamilia(familiaSeleccionada);
    final listaProducto =
        fecthMenuRepository.findProductoById(subFamiliaSeleccionada);

    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        actions: widget.menuPrincipal
            ? mostrarUsuario
                ? const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: AppBarItemButton(
                          icon: Icons.supervised_user_circle_outlined,
                          label: 'Usuario'),
                    )
                  ]
                : null
            : null,
        backgroundColor: mostrarUsuario
            ? null
            : Theme.of(context).colorScheme.primaryContainer,
        centerTitle: widget.menuPrincipal ? true : false,
        title: widget.menuPrincipal
            ? productosAgregados.isEmpty
                ? null
                : appBarCheckOut()
            : Text(widget.titleSection),
        toolbarHeight: 35,
        leading: widget.menuPrincipal
            ? productosAgregados.isEmpty
                ? speedDial()
                : const SizedBox.shrink()
            : null,
      ),
      body: StreamBuilder3(
        streams: StreamTuple3(listaFamilia, listaSubFamilia, listaProducto),
        builder: (context, snapshot) {
          if (!snapshot.snapshot1.hasData &&
              !snapshot.snapshot2.hasData &&
              !snapshot.snapshot3.hasData) {
            return const Center(child: CircularProgressIndicator());
          } else {
            final itemFamilia = snapshot.snapshot1.data;
            final itemSubFamilia = snapshot.snapshot2.data;
            final itemProducto = snapshot.snapshot3.data;
            return _buildMenuBody(
              size,
              itemFamilia,
              itemSubFamilia,
              itemProducto,
              joinedCantidad,
              borderColor,
            );
          }
        },
      ),
    );
  }

//AppBar buttons
  Widget appBarCheckOut() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            mostrarIdentificador = true;
            setState(() {});
          },
          child: const AppBarItemButton(
            icon: Icons.add_shopping_cart,
            label: 'En Espera',
          ),
        ),
        const AppBarItemButton(
          icon: Icons.print_rounded,
          label: 'Sub-Total',
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/venta',
                arguments: CheckOutArgument(
                    productoAgregado: productosAgregados,
                    totalVenta: totalVenta,
                    fechaVenta: DateTime.now()));
          },
          child:
              const AppBarItemButton(icon: Icons.euro_rounded, label: 'Pago'),
        ),
      ],
    );
  }

  SpeedDial speedDial() {
    return SpeedDial(
      onOpen: () {
        mostrarUsuario = false;
        setState(() {});
      },
      onClose: () {
        mostrarUsuario = true;
        setState(() {});
      },
      backgroundColor: Colors.transparent,
      elevation: 0,
      spaceBetweenChildren: 10.0,
      direction: SpeedDialDirection.right,
      overlayOpacity: 0.0,
      animatedIcon: AnimatedIcons.view_list,
      children: [
        speedDialItems('Proveedores', Icons.forklift, ProveedorView.routeName),
        speedDialItems(
            'Estadistica', Icons.stacked_bar_chart, ProveedorView.routeName),
        speedDialItems(
            'Inventario', Icons.inventory_rounded, ProveedorView.routeName),
        speedDialItems('Horario', Icons.schedule, ProveedorView.routeName),
        speedDialItems(
            'Configuracion', Icons.settings, ProveedorView.routeName),
      ],
    );
  }

  SpeedDialChild speedDialItems(String label, IconData icono, String route) {
    return SpeedDialChild(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      labelWidget: AppBarItemButton(icon: icono, label: label),
      elevation: 0,
    );
  }

//Metodos utilizados para body del menu
  Widget _buildMenuBody(
      Size size,
      List<Familia>? itemFamilia,
      List<SubFamilia?>? itemSubFamilia,
      List<Producto?>? itemProducto,
      String joinedCantidad,
      Color borderColor) {
    final PagoRepository fecthPagoRepository =
        localService.get<PagoRepository>();
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: size.width * 0.205,
                child: ListFamilia(
                    selectedFamiliaIndex: selectedFamiliaIndex,
                    itemFamilia: itemFamilia,
                    onFamiliaTap: onFamiliaTap),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.15,
                        child: RowSubFamilia(
                          selectedSubFamiliaIndex: selectedSubFamiliaIndex,
                          itemSubFamilia: itemSubFamilia,
                          onSubFamiliaTap: onSubFamiliaTap,
                        ),
                      ),
                      Expanded(
                        child: GridProducto(
                          selectedProductoIndex: selectedProductoIndex,
                          itemProducto: itemProducto,
                          joinedCantidad: joinedCantidad,
                          borderColor: borderColor,
                          onProductTap: onProductTap,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.15),
                    )),
                width: size.width * 0.3,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: CheckOut(
                    mostrarTeclado: mostrarTeclado,
                    mostrarIdentificador: mostrarIdentificador,
                    productosAgregados: productosAgregados,
                    totalVenta: totalVenta,
                    selectedItemLista: selectedItemLista,
                    isMenuPrincipal: widget.menuPrincipal,
                    cantidadProducto: cantidadProducto,
                    titleSection: widget.titleSection,
                    hideKeyboard: dropDownIcon,
                    actualizarCantidad: actualizarCantidad(joinedCantidad),
                    onTextIdentificadorTap: onTextIdentificadorTap,
                    onBackIdentificador: onBackIdentificador,
                    onAceptarIdentificador: onAceptarIdentificador,
                    clearButton: clearButton,
                    onTapNum: onTapNum,
                    sectionActionButton: () {
                      productosAgregados.isNotEmpty
                          ? _builAlertDialog(fecthPagoRepository)
                          : null;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Future<dynamic> _builAlertDialog(PagoRepository fecthPagoRepository) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text(
              widget.titleSection,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            content: widget.devolucion
                ? _buildContentDevolucion(fecthPagoRepository)
                : const Text(
                    'Los productos agregados a la lista seran guardados como una consumicion propia.'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    tipoDevolucion = null;
                  },
                  child: const Text('Cancelar')),
              FilledButton(
                  onPressed: () {
                    widget.devolucion
                        ? _saveVenta(fecthPagoRepository, 2)
                        : _saveVenta(fecthPagoRepository, 1);
                    Navigator.pop(context);
                  },
                  child: const Text('Aceptar'))
            ],
          );
        });
  }

  StatefulBuilder _buildContentDevolucion(PagoRepository repository) {
    return StatefulBuilder(builder: (context, setState) {
      return StreamBuilder(
        stream: repository.findAllTipoDevolucion().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Seleccione la razon de la devolucion:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  DropdownButton(
                    value: tipoDevolucion,
                    hint: const Text('Razon de devolucion'),
                    isExpanded: true,
                    items: snapshot.data!
                        .map((value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                              ),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() => tipoDevolucion = value);
                    },
                  ),
                  tipoDevolucion != null
                      ? Text(
                          'Los productos seran registrados como una devolucion por $tipoDevolucion',
                          style: Theme.of(context).textTheme.labelSmall,
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      );
    });
  }

  Future<void> _saveVenta(
      PagoRepository fecthPagoRepository, int idTipoVenta) async {
    final idVenta = DateTime.now().millisecondsSinceEpoch;
    final tipoVenta = await fecthPagoRepository.findTipoVentaById(idTipoVenta);

    fecthPagoRepository.insertVenta(Venta(
        idVenta: idVenta,
        metodoPago: 'Tarjeta',
        costeTotal: 0,
        ingresoTotal: 0,
        fecha: fechaFormatter(DateTime.now()),
        idUsuario: 0,
        nombreCliente:
            widget.devolucion ? tipoDevolucion! : widget.titleSection,
        tipoVenta: tipoVenta!));

    for (var element in productosAgregados) {
      fecthPagoRepository.insertDetalleVenta(DetalleVenta(
          idVenta: idVenta,
          productoId: element!.productoId,
          cantidad: int.parse(element.cantidad),
          precioUnitario: element.precio,
          descuento: 0,
          entregado: true,
          idDetalleVenta: UniqueKey().toString()));
    }
    cantidad.clear();
    productosAgregados.clear();
    setState(() {});
  }

  dropDownIcon() {
    mostrarTeclado = !mostrarTeclado;
    setState(() {});
  }

  void changeIndex(int index, ValueNotifier<int?> notifier) {
    notifier.value = index;
  }

  void onFamiliaTap(Familia familia, int index) {
    return setState(() {
      selectedSubFamiliaIndex.value = null;
      selectedProductoIndex.value = null;
      subFamiliaSeleccionada = "";
      familiaSeleccionada = familia.idFamilia;
      changeIndex(index, selectedFamiliaIndex);
    });
  }

  void onSubFamiliaTap(SubFamilia subFamilia, int index) {
    return setState(() {
      if (selectedSubFamiliaIndex.value == index) {
        selectedSubFamiliaIndex.value = null;
        selectedProductoIndex.value = null;
        subFamiliaSeleccionada = '';
      } else {
        subFamiliaSeleccionada = subFamilia.idSubfamilia;
        changeIndex(index, selectedSubFamiliaIndex);
      }
    });
  }

  void onProductTap(int index, Producto producto, String joinedCantidad) {
    setState(() {
      if (cantidad.isNotEmpty) {
        productosAgregados.add(ProductoOrdenado(
            productoId: producto.productoId,
            nombreProducto: producto.producto,
            precio: producto.precio,
            cantidad: joinedCantidad,
            iva: producto.iva,
            fecha: DateTime.now()));

        totalVenta += producto.precio * double.parse(joinedCantidad);
        cantidad.clear();
        mostrarTeclado = false;

        setState(() {});
      }
    });
  }

//Metodos utilizados CardCheckOut
  void clearButton() {
    productosAgregados.clear();
    totalVenta = 0;
    setState(() {});
  }

  void onAceptarIdentificador() {
    if (identificadorVenta != '') {
      final List<ProductoOrdenado?> productosEspera = [];
      productosEspera.addAll(productosAgregados);
      context.read<VentaEsperaProvider>().addProductoEspera(
          producto: productosEspera,
          idVenta: identificadorVenta,
          totalVenta: totalVenta);
      totalVenta = 0;
      mostrarIdentificador = false;
      selectedProductoIndex.value = null;
      productosAgregados.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        content: Text(
          'Venta agregada a lista de espera',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
        duration: Durations.extralong4,
      ));
      setState(() {});
    }
  }

  void onBackIdentificador() {
    mostrarIdentificador = false;
    setState(() {});
  }

  void onTextIdentificadorTap(String value) {
    identificadorVenta = value;
    setState(() {});
  }

  void onTapNum(String label) {
    cantidad.add(label);
    setState(() {});
  }

  Future<void> actualizarCantidad(String joinedCantidad) async {
    cantidadProducto = joinedCantidad;
  }
}
