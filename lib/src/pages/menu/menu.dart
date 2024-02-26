import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:jarv/src/utils/models/arguments_check_out.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../../data_source/db.dart';
import '../../widgets/card_button.dart';

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
  bool mostrarTeclado = false;
  bool mostrarUsuario = true;

  List<String> cantidad = [];

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);

  ProductoPreOrdenado _productoPreOrdenado = ProductoPreOrdenado(
      productoId: '', nombreProducto: '', precio: 0, cantidad: '');
  double totalVenta = 0;

  List<ProductoPreOrdenado?> productosAgregados = [];

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
        title: productosAgregados.isEmpty
            ? Text(mostrarUsuario ? 'Usuario' : '')
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  appItemButton(
                      Icons.add_shopping_cart, 'En Espera', '/settings'),
                  appItemButton(Icons.print_rounded, 'Sub-Total', '/settings'),
                  appItemButton(Icons.money, 'Pago', '/venta'),
                ],
              ),
        backgroundColor: const Color.fromARGB(255, 170, 117, 255),
        leading:
            productosAgregados.isEmpty ? speedDial() : const SizedBox.shrink(),
        centerTitle: true,
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

            return _buildMenuBody(size, itemFamilia, itemSubFamilia,
                itemProducto, joinedCantidad, borderColor);
          }
        },
      ),
    );
  }

//AppBar buttons
  Widget appItemButton(IconData icon, String label, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName,
            arguments: CheckOutArgument(
              productoAgregado: productosAgregados,
              totalVenta: totalVenta,
            ));
        setState(() {});
      },
      child: Padding(
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
      ),
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
        speedDialItems('Proveedores', Icons.forklift, '/settings'),
        speedDialItems('Estadistica', Icons.stacked_bar_chart, '/settings'),
        speedDialItems('Inventario', Icons.inventory_rounded, '/settings'),
        speedDialItems('Configuracion', Icons.settings, '/settings'),
        speedDialItems('Horario', Icons.schedule, '/settings'),
      ],
    );
  }

  SpeedDialChild speedDialItems(String label, IconData icono, routeName) {
    return SpeedDialChild(
      labelWidget: appItemButton(icono, label, routeName),
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
    return Column(
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width * 0.15,
                child: _buildListFamilia(itemFamilia),
              ),
              Column(
                children: [
                  SizedBox(
                      height: size.height * 0.17,
                      width: size.width * 0.45,
                      child: _buildListSubFamilia(itemSubFamilia, size)),
                  Expanded(
                    child: SizedBox(
                      width: size.width * 0.45,
                      child: _buildGridProducto(
                          itemProducto, size, joinedCantidad, borderColor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: size.width * 0.4,
                child: _buildCheckOut(size, joinedCantidad, borderColor),
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

  GridView _buildGridProducto(List<Producto?>? itemProducto, Size size,
      String joinedCantidad, Color borderColor) {
    final SliverGridDelegateWithFixedCrossAxisCount grid =
        SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      mainAxisSpacing: 0,
      crossAxisSpacing: 10,
      mainAxisExtent: size.height * 0.5,
    );
    return GridView.builder(
      itemCount: itemProducto?.length ?? 0,
      gridDelegate: grid,
      itemBuilder: (context, index) {
        Producto? producto = itemProducto![index];

        return GestureDetector(
          onTap: () => onProductTap(index, producto, joinedCantidad),
          child: Card(
            shadowColor: const Color.fromARGB(255, 1, 24, 63),
            elevation: selectedProductoIndex.value == index ? 15 : 0,
            shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    color: selectedProductoIndex.value == index
                        ? const Color.fromARGB(255, 1, 27, 39)
                        : borderColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: size.height * 0.25,
                  width: size.height * 0.2,
                  child: const FadeInImage(
                      placeholder: AssetImage('assets/images/load.gif'),
                      image: NetworkImage(
                          "https://s1.eestatic.com/2021/07/12/actualidad/595952167_195030066_1706x960.jpg")),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Container(
                      color: const Color.fromARGB(85, 145, 145, 145),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            producto!.producto,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text(
                    '${producto.precio} €',
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView _buildListSubFamilia(List<SubFamilia?>? itemSubFamilia, Size size) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemSubFamilia?.length ?? 0,
      itemBuilder: (context, index) {
        SubFamilia? subFamilia = itemSubFamilia![index];
        return GestureDetector(
            onTap: () => onSubFamiliaTap(subFamilia, index),
            child: SizedBox(
              width: size.width * 0.15,
              child: CardButton(
                  content: subFamilia!.nombreSub,
                  valueNotifier: selectedSubFamiliaIndex,
                  colorSelected: Colors.blueGrey,
                  posicion: index),
            ));
      },
    );
  }

  ListView _buildListFamilia(List<Familia>? itemFamilia) {
    return ListView.builder(
      itemCount: itemFamilia?.length,
      itemBuilder: (context, index) {
        Familia? familia = itemFamilia![index];

        return GestureDetector(
          onTap: () => onFamiliaTap(familia, index),
          child: CardButton(
            valueNotifier: selectedFamiliaIndex,
            colorSelected: Colors.blueAccent,
            content: familia.nombreFamilia,
            posicion: index,
          ),
        );
      },
    );
  }

  Row _footerActions(Size size, Color borderColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: size.width * 0.15,
          child: footerButton(borderColor,
              const Color.fromARGB(148, 248, 113, 113), 'Cierre Diario'),
        ),
        SizedBox(
          width: size.width * 0.15,
          child: footerButton(borderColor,
              const Color.fromARGB(147, 163, 162, 162), 'Ticket Diario'),
        ),
        SizedBox(
          width: size.width * 0.15,
          child: footerButton(borderColor,
              const Color.fromARGB(147, 163, 162, 162), 'Ventas en Espera'),
        ),
        SizedBox(
          width: size.width * 0.15,
          child: footerButton(
              borderColor, const Color.fromARGB(147, 163, 162, 162), 'Cliente'),
        ),
      ],
    );
  }

  Widget footerButton(Color color, Color bodyColor, String label) {
    return Container(
      decoration:
          BoxDecoration(color: bodyColor, border: Border.all(color: color)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(label)),
      ),
    );
  }

  void hideKeyBoard() {
    selectedProductoIndex.value = null;
    mostrarTeclado = false;
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
      hideKeyBoard();
    });
  }

  void onSubFamiliaTap(SubFamilia subFamilia, int index) {
    return setState(() {
      if (selectedSubFamiliaIndex.value == index) {
        selectedSubFamiliaIndex.value = null;
        subFamiliaSeleccionada = '';
      } else {
        subFamiliaSeleccionada = subFamilia.idSubfamilia;
        changeIndex(index, selectedSubFamiliaIndex);
        hideKeyBoard();
      }
    });
  }

  void onProductTap(int index, Producto producto, String joinedCantidad) {
    setState(() {
      if (selectedProductoIndex.value == index) {
        hideKeyBoard();
        _productoPreOrdenado = ProductoPreOrdenado(
            productoId: '', nombreProducto: '', precio: 0, cantidad: '');
      } else {
        changeIndex(index, selectedProductoIndex);
        mostrarTeclado = true;
      }
      _productoPreOrdenado = ProductoPreOrdenado(
          productoId: producto.productoId,
          nombreProducto: producto.producto,
          precio: producto.precio,
          cantidad: joinedCantidad);
    });
  }

//Metodos utilizados para construir CheckOut
  Widget _buildCheckOut(Size size, String joinedCantidad, Color borderColor) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(5)),
        elevation: 7,
        child: Column(
          children: [
            _listaProductoOrdenados(size),
            _totalVenta(size),
            _elementoPreOrdenado(joinedCantidad, size),
            _teclado(size, joinedCantidad)
          ],
        ),
      ),
    );
  }

  Widget _totalVenta(Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: mostrarTeclado ? false : true,
            child: ElevatedButton.icon(
                icon: const Icon(Icons.clear_all_rounded),
                onPressed: () {
                  productosAgregados.clear();
                  totalVenta = 0;
                  setState(() {});
                },
                label: const Text('Limpiar Lista')),
          ),
          Text(totalVenta != 0.0 ? '€ ${totalVenta.toString()}' : '')
        ],
      ),
    );
  }

  Widget _listaProductoOrdenados(Size size) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: size.width * 0.35,
        height: mostrarTeclado ? size.height * 0.09 : size.height * 0.45,
        child: ListView.builder(
          itemCount: productosAgregados.length,
          itemBuilder: (BuildContext context, int index) {
            final ProductoPreOrdenado? producto = productosAgregados[index];
            final double total =
                double.parse(producto!.cantidad) * producto.precio;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        visualDensity: mostrarTeclado
                            ? VisualDensity.compact
                            : VisualDensity.comfortable,
                        title: Text(producto.nombreProducto),
                        subtitle:
                            Text('${producto.cantidad} x ${producto.precio}€'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(total.toString()),
                    ),
                  ],
                ),
                Divider(
                  height: size.height * 0.1,
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _teclado(Size size, String joinedCantidad) {
    return Visibility(
      visible: mostrarTeclado,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: VirtualKeyboard(
                  type: VirtualKeyboardType.Numeric,
                  height: size.height * 0.15,
                  fontSize: 12,
                  onKeyPress: (key) async {
                    await keyboardAction(key, joinedCantidad);
                  }),
            ),
            ElevatedButton.icon(
              onPressed: addButton,
              label: const Text("Anadir"),
              icon: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> _elementoPreOrdenado(String joinedCantidad, Size size) {
    return FutureBuilder(
        future: actualizarCantidad(joinedCantidad),
        builder: (context, snapahot) {
          return Visibility(
            visible: mostrarTeclado,
            child: Container(
                color: const Color.fromARGB(50, 54, 54, 54),
                height: size.height * 0.1,
                width: size.width * 0.4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(_productoPreOrdenado.nombreProducto),
                    Text(_productoPreOrdenado.cantidad),
                    Text('€ ${_productoPreOrdenado.precio.toString()}'),
                  ],
                )),
          );
        });
  }

  void addButton() {
    if (cantidad.isNotEmpty) {
      productosAgregados.add(ProductoPreOrdenado(
          productoId: _productoPreOrdenado.productoId,
          nombreProducto: _productoPreOrdenado.nombreProducto,
          precio: _productoPreOrdenado.precio,
          cantidad: _productoPreOrdenado.cantidad));

      totalVenta += _productoPreOrdenado.precio *
          double.parse(_productoPreOrdenado.cantidad);
      cantidad.clear();
      hideKeyBoard();
      setState(() {});
    }
  }

  Future<void> keyboardAction(key, String joinedCantidad) async {
    if (key.keyType != VirtualKeyboardKeyType.Action) {
      cantidad.add(key.capsText!);
      await actualizarCantidad(joinedCantidad);
    } else if (key.action == VirtualKeyboardKeyAction.Backspace) {
      cantidad.removeLast();
    }

    setState(() {});
  }

  Future<void> actualizarCantidad(String joinedCantidad) async {
    _productoPreOrdenado.cantidad = joinedCantidad;
  }
}
