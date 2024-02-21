import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../data_source/db.dart';
import '../widgets/card_button.dart';
import '../widgets/check_out_card.dart';

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
  bool isVisible = true;
  bool showKeyboard = false;

  List<String> cantidad = [];

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);

  ProductoPreOrdenado _productoPreOrdenado = ProductoPreOrdenado(
      productoId: '', nombreProducto: '', precio: 0, cantidad: '');
  List<ProductoPreOrdenado?> productosAgregados = [];

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: const Color.fromARGB(255, 172, 132, 241),
        leading: const Center(child: Text("JARV")),
        centerTitle: true,
        title: const Text("Usuario"),
        actions: [
          Center(
              child: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ))
        ],
      ),
      body: StreamBuilder3(
        streams: StreamTuple3(listaFamilia, listaSubFamilia, listaProducto),
        builder: (context, snapshot) {
          if (!snapshot.snapshot1.hasData &&
              !snapshot.snapshot2.hasData &&
              !snapshot.snapshot3.hasData) {
            return const CircularProgressIndicator();
          } else {
            final itemFamilia = snapshot.snapshot1.data;
            final itemSubFamilia = snapshot.snapshot2.data;
            final itemProducto = snapshot.snapshot3.data;

            return _buildMenuBody(size, itemFamilia, itemSubFamilia,
                itemProducto, joinedCantidad);
          }
        },
      ),
    );
  }

  Widget _buildMenuBody(
      Size size,
      List<Familia>? itemFamilia,
      List<SubFamilia?>? itemSubFamilia,
      List<Producto?>? itemProducto,
      String joinedCantidad) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: size.width * 0.15,
          child: builderColumnFamilia(itemFamilia),
        ),
        Column(
          children: [
            SizedBox(
                height: size.height * 0.17,
                width: size.width * 0.45,
                child: buildeGridSubFamilia(itemSubFamilia, size)),
            Expanded(
              child: SizedBox(
                width: size.width * 0.45,
                child: builderGridProducto(itemProducto, size, joinedCantidad),
              ),
            ),
          ],
        ),
        CheckoutCard(
          productoPreOrdenado: _productoPreOrdenado,
          size: size,
          productosOrdenados: productosAgregados,
          show: showKeyboard,
          keyPress: (VirtualKeyboardKey key) async {
            await keyBoardAction(key, joinedCantidad);
          },
          actualizarCantidad: actualizarCantidad(joinedCantidad),
        )
      ],
    );
  }

  GridView builderGridProducto(
      List<Producto?>? itemProducto, Size size, String joinedCantidad) {
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
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(
                    width: 1,
                    color: selectedProductoIndex.value == index
                        ? const Color.fromARGB(255, 1, 27, 39)
                        : const Color.fromARGB(59, 7, 7, 7))),
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

  ListView buildeGridSubFamilia(List<SubFamilia?>? itemSubFamilia, Size size) {
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

  ListView builderColumnFamilia(List<Familia>? itemFamilia) {
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

  void hideKeyBoard() {
    selectedProductoIndex.value = null;
    showKeyboard = false;
  }

  void changeIndex(int index, ValueNotifier<int?> notifier) {
    notifier.value = index;
  }

  void onFamiliaTap(Familia familia, int index) {
    return setState(() {
      selectedSubFamiliaIndex.value = null;
      subFamiliaSeleccionada = "";

      familiaSeleccionada = familia.idFamilia;
      isVisible = true;

      changeIndex(index, selectedFamiliaIndex);
      hideKeyBoard();
    });
  }

  void onSubFamiliaTap(SubFamilia subFamilia, int index) {
    return setState(() {
      subFamiliaSeleccionada = subFamilia.idSubfamilia;

      changeIndex(index, selectedSubFamiliaIndex);
      hideKeyBoard();
    });
  }

  void onProductTap(int index, Producto producto, String joinedCantidad) {
    setState(() {
      if (selectedProductoIndex.value == index) {
        hideKeyBoard();
      } else {
        changeIndex(index, selectedProductoIndex);
        showKeyboard = true;
      }
      _productoPreOrdenado = ProductoPreOrdenado(
          productoId: producto.productoId,
          nombreProducto: producto.producto,
          precio: producto.precio,
          cantidad: joinedCantidad);
    });
  }

  Future<void> keyBoardAction(
      VirtualKeyboardKey key, String joinedCantidad) async {
    if (key.keyType != VirtualKeyboardKeyType.Action) {
      cantidad.add(key.capsText!);
      await actualizarCantidad(joinedCantidad);
    } else if (key.action == VirtualKeyboardKeyAction.Backspace) {
      cantidad.removeLast();
    }

    setState(() {});
  }

  Future<void> actualizarCantidad(String joinedCantidad) async {
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() {
      _productoPreOrdenado.cantidad = joinedCantidad;
    });
  }
}
