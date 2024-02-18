import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import '../DB/db.dart';
import '../widgets/card_button.dart';

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

  String? cantidad;

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);

  List<Producto?> productosAgregados = [];

  @override
  Widget build(BuildContext context) {
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
                        child: builderGridProducto(itemProducto, size),
                      ),
                    ),
                  ],
                ),
                CheckoutCard(
                  cantidad: cantidad,
                  size: size,
                  itemProducto: itemProducto,
                  show: showKeyboard,
                  keyPress: (VirtualKeyboardKey key) {
                    setState(() {
                      cantidad = key.capsText;
                    });
                  },
                )
              ],
            );
          }
        },
      ),
    );
  }

  GridView builderGridProducto(List<Producto?>? itemProducto, Size size) {
    return GridView.builder(
      itemCount: itemProducto?.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // number of items in each row
        mainAxisSpacing: 0, // spacing between rows
        crossAxisSpacing: 10,
        mainAxisExtent: size.height * 0.45,
      ),
      itemBuilder: (context, index) {
        Producto? producto = itemProducto![index];
        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedProductoIndex.value == index) {
                hideKeyBoard();
              } else {
                selectedProductoIndex.value = index;
                showKeyboard = true;
              }
            });
          },
          child: Card(
            shadowColor: const Color.fromARGB(255, 1, 24, 63),
            elevation: selectedProductoIndex.value == index ? 15 : 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
                side: BorderSide(
                  width: 1,
                  color: selectedProductoIndex.value == index
                      ? const Color.fromARGB(255, 1, 27, 39)
                      : Colors.transparent,
                )),
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

  void hideKeyBoard() {
    selectedProductoIndex.value = null;
    showKeyboard = false;
  }

  ListView buildeGridSubFamilia(List<SubFamilia?>? itemSubFamilia, Size size) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemSubFamilia?.length ?? 0,
      itemBuilder: (context, index) {
        SubFamilia? subFamilia = itemSubFamilia![index];
        return GestureDetector(
            onTap: () {
              setState(() {
                selectedSubFamiliaIndex.value = index;
                subFamiliaSeleccionada = subFamilia.idSubfamilia;
                hideKeyBoard();
              });
            },
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
          onTap: () {
            setState(() {
              selectedFamiliaIndex.value = index;
              selectedSubFamiliaIndex.value = null;
              familiaSeleccionada = familia.idFamilia;
              subFamiliaSeleccionada = "";

              isVisible = true;
              hideKeyBoard();
            });
          },
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
}

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    super.key,
    required this.size,
    this.itemProducto,
    required this.show,
    this.keyPress,
    required this.cantidad,
  });
  final String? cantidad;
  final Size size;
  final List<Producto?>? itemProducto;
  final bool show;
  final Function? keyPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.40,
      color: const Color.fromARGB(255, 228, 228, 228),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color.fromARGB(94, 97, 97, 97)),
              borderRadius: BorderRadius.circular(5)),
          elevation: 7,
          child: Column(children: [
            SizedBox(
              width: size.width * 0.35,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: size.width * 0.05,
                      child: const Text(
                        "Name",
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      child: const Text(
                        "Qty",
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      child: const Text("Each"),
                    ),
                    SizedBox(
                      width: size.width * 0.05,
                      child: const Text("Total"),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(94, 97, 97, 97))),
                width: size.width * 0.35,
                child: ListView.builder(
                  itemCount: itemProducto?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    final Producto? producto = itemProducto![index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: size.width * 0.05,
                                child: Text(
                                  producto!.producto,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                color: Colors.amber,
                                child: SizedBox(
                                  width: size.width * 0.05,
                                  child: Text(
                                    cantidad.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                                child: Text(producto.precio.toString()),
                              ),
                              SizedBox(
                                width: size.width * 0.05,
                                child: Text(producto.precio.toString()),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Divider(
                              thickness: 1.5,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: show,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: VirtualKeyboard(
                          type: VirtualKeyboardType.Numeric,
                          height: size.height * 0.2,
                          onKeyPress: keyPress,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      label: const Text("Anadir"),
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("TOTAL:"),
                  SizedBox(
                    width: size.width * 0.05,
                  ),
                  const Text("12.98"),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
