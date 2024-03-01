import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';
import 'package:jarv/src/widgets/menu/grid_producto.dart';
import 'package:jarv/src/widgets/menu/list_familia.dart';
import 'package:jarv/src/widgets/menu/row_sub_familia.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:provider/provider.dart';

import '../../data_source/db.dart';
import '../../utils/provider/venta_espera_provider.dart';
import '../../widgets/menu/check_out_card.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen(
      {super.key,
      required this.familia,
      required this.subFamilia,
      required this.producto});

  final FamiliaDao familia;
  final SubFamiliaDao subFamilia;
  final ProductoDao producto;

  static const routeName = "/menu";

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String familiaSeleccionada = "";
  String subFamiliaSeleccionada = "";

  bool mostrarUsuario = true;
  bool mostrarIdentificador = false;

  List<String> cantidad = [];

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);

  ProductoPreOrdenado _productoPreOrdenado = ProductoPreOrdenado(
      productoId: '', nombreProducto: '', precio: 0, cantidad: '');
  double totalVenta = 0;

  List<ProductoPreOrdenado?> productosAgregados = [];
  List<ProductoPreOrdenado?> productosEspera = [];
  String? identificadorVenta;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color.fromARGB(59, 7, 7, 7);

    final String joinedCantidad =
        cantidad.map((e) => int.parse(e)).toList().join();
    final listaFamilia = widget.familia.findAllFamilias().asStream();
    final listaSubFamilia = widget.subFamilia
        .findSubFamiliaByFamilia(familiaSeleccionada)
        .asStream();
    final listaProducto = widget.producto
        .findProductoBySubFamiliaId(subFamiliaSeleccionada)
        .asStream();
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: productosAgregados.isEmpty
            ? Text(mostrarUsuario ? 'Usuario' : '')
            : appBarCheckOut(),
        toolbarHeight: 45,
        backgroundColor: const Color.fromARGB(255, 170, 117, 255),
        leading:
            productosAgregados.isEmpty ? speedDial() : const SizedBox.shrink(),
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

  Widget appBarCheckOut() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector(
          onTap: () {
            mostrarIdentificador = true;
            setState(() {});
          },
          child: appItemButton(
            Icons.add_shopping_cart,
            'En Espera',
            '/espera',
          ),
        ),
        appItemButton(
          Icons.print_rounded,
          'Sub-Total',
          '/settings',
        ),
        GestureDetector(
          onTap: () {
            checkOutAction(
                '/venta',
                CheckOutArgument(
                    productoAgregado: productosAgregados,
                    totalVenta: totalVenta));
          },
          child: appItemButton(
            Icons.euro_rounded,
            'Pago',
            '/venta',
          ),
        ),
      ],
    );
  }

//AppBar buttons
  Widget appItemButton(IconData icon, String label, String routeName) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            label,
          )
        ],
      ),
    );
  }

  checkOutAction(String routeName, argument) {
    Navigator.pushNamed(context, routeName, arguments: argument);
    setState(() {});
  }

  appBarAction(String routeName) {
    Navigator.pushNamed(context, routeName);
    setState(() {});
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
        speedDialItems('Proveedores', Icons.forklift, '/settings'),
        speedDialItems('Estadistica', Icons.stacked_bar_chart, '/settings'),
        speedDialItems('Inventario', Icons.inventory_rounded, '/settings'),
        speedDialItems('Horario', Icons.schedule, '/settings'),
        speedDialItems('Configuracion', Icons.settings, '/settings'),
      ],
    );
  }

  SpeedDialChild speedDialItems(String label, IconData icono, routeName) {
    return SpeedDialChild(
      labelWidget: appItemButton(icono, label, routeName),
      elevation: 0,
    );
  }

//Butones del footer
  Widget _footerActions(Size size, Color borderColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: size.width * 0.15,
          child: footerButton(borderColor,
              const Color.fromARGB(148, 248, 113, 113), 'Cierre Diario'),
        ),
        SizedBox(
          width: size.width * 0.05,
        ),
        Expanded(
          child: footerButton(borderColor,
              const Color.fromARGB(147, 163, 162, 162), 'Ticket Diario'),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/espera');
            },
            child: footerButton(borderColor,
                const Color.fromARGB(147, 163, 162, 162), 'Ventas en Espera'),
          ),
        ),
        Expanded(
          child: footerButton(
              borderColor, const Color.fromARGB(147, 163, 162, 162), 'Cliente'),
        ),
      ],
    );
  }

  Container footerButton(Color color, Color bodyColor, String label) {
    return Container(
      decoration: BoxDecoration(
        color: bodyColor,
        border: Border.all(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(label)),
      ),
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
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListFamilia(
                  selectedFamiliaIndex: selectedFamiliaIndex,
                  itemFamilia: itemFamilia,
                  onFamiliaTap: onFamiliaTap),
              Column(
                children: [
                  RowSubFamilia(
                    selectedSubFamiliaIndex: selectedSubFamiliaIndex,
                    itemSubFamilia: itemSubFamilia,
                    onSubFamiliaTap: onSubFamiliaTap,
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
              SizedBox(
                width: size.width * 0.4,
                child: CheckOut(
                  cantidad: cantidad,
                  mostrarIdentificador: mostrarIdentificador,
                  productosAgregados: productosAgregados,
                  totalVenta: totalVenta,
                  productoPreOrdenado: _productoPreOrdenado,
                  actualizarCantidad: actualizarCantidad(joinedCantidad),
                  onTextIdentificadorTap: onTextIdentificadorTap,
                  onBackIdentificador: onBackIdentificador,
                  onAceptarIdentificador: onAceptarIdentificador,
                  clearButton: clearButton,
                  addAction: addAction,
                  onTapNum: onTapNum,
                  backspace: backspace,
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _footerActions(size, borderColor),
        )
      ],
    );
  }

  void changeIndex(int index, ValueNotifier<int?> notifier) {
    notifier.value = index;
  }

  void onFamiliaTap(Familia familia, int index) {
    return setState(() {
      selectedSubFamiliaIndex.value = null;
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
      if (selectedProductoIndex.value == index) {
        _productoPreOrdenado = ProductoPreOrdenado(
            productoId: '', nombreProducto: '', precio: 0, cantidad: '');
        selectedProductoIndex.value = null;
      } else {
        changeIndex(index, selectedProductoIndex);
        _productoPreOrdenado = ProductoPreOrdenado(
            productoId: producto.productoId,
            nombreProducto: producto.producto,
            precio: producto.precio,
            cantidad: joinedCantidad);
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
    context
        .read<VentaEsperaProvider>()
        .addProducto(producto: productosAgregados);

    context
        .read<VentaEsperaProvider>()
        .addIdentificadores(nuevoIdentificador: identificadorVenta);
    context.read<VentaEsperaProvider>().updateTotal(nuevoTotal: totalVenta);

    totalVenta = 0;
    mostrarIdentificador = false;
    selectedSubFamiliaIndex.value = null;
    selectedFamiliaIndex.value = null;
    selectedProductoIndex.value = null;
    productosAgregados.clear();
    Navigator.pushNamed(context, '/espera');
    // checkOutAction(
    //     '/espera', VentaEsperaArgument(productosEspera, identificadoresVenta));
    //mostrarIdentificador = false;
    setState(() {});
  }

  void onBackIdentificador() {
    mostrarIdentificador = false;
    setState(() {});
  }

  void onTextIdentificadorTap(String value) {
    identificadorVenta = value;
    setState(() {});
  }

  void backspace(List<String> cantidad) {
    cantidad.removeLast();
    setState(() {});
  }

  void onTapNum(String label) {
    cantidad.add(label);
    setState(() {});
  }

  void addAction(List<String> cantidad) {
    if (cantidad.isNotEmpty && _productoPreOrdenado.nombreProducto.isNotEmpty) {
      productosAgregados.add(ProductoPreOrdenado(
          productoId: _productoPreOrdenado.productoId,
          nombreProducto: _productoPreOrdenado.nombreProducto,
          precio: _productoPreOrdenado.precio,
          cantidad: _productoPreOrdenado.cantidad));

      totalVenta += _productoPreOrdenado.precio *
          double.parse(_productoPreOrdenado.cantidad);
      cantidad.clear();
      _productoPreOrdenado = ProductoPreOrdenado(
          productoId: '', nombreProducto: '', precio: 0, cantidad: '');
      selectedProductoIndex.value = null;
      setState(() {});
    }
  }

  Future<void> actualizarCantidad(String joinedCantidad) async {
    _productoPreOrdenado.cantidad = joinedCantidad;
  }
}
