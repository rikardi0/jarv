import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';

class CheckOut extends StatelessWidget {
  const CheckOut(
      {super.key,
      required this.mostrarIdentificador,
      required this.productosAgregados,
      required this.totalVenta,
      required this.productoPreOrdenado,
      required this.actualizarCantidad,
      this.onTextIdentificadorTap,
      this.onBackIdentificador,
      this.onAceptarIdentificador,
      this.clearButton,
      this.onTapNum,
      this.addAction,
      required this.cantidad,
      this.backspace,
      required this.showTeclado,
      this.dropDownIcon,
      this.deslizarItem,
      required this.selectedItemLista,
      this.onTapItem,
      required this.menuPrincipal});

  final bool mostrarIdentificador;
  final bool showTeclado;
  final bool menuPrincipal;
  final List<ProductoPreOrdenado?> productosAgregados;
  final double totalVenta;
  final ProductoPreOrdenado productoPreOrdenado;
  final List<String> cantidad;
  final Future<void> actualizarCantidad;
  final ValueNotifier<int?> selectedItemLista;
  final dynamic onTextIdentificadorTap;
  final dynamic onBackIdentificador;
  final dynamic onAceptarIdentificador;
  final dynamic clearButton;
  final dynamic onTapNum;
  final dynamic addAction;
  final dynamic backspace;
  final dynamic dropDownIcon;
  final dynamic deslizarItem;
  final dynamic onTapItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(59, 7, 7, 7)),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
      elevation: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _listaProductoOrdenado(context),
          _totalVenta(),
          _elementoPreOrdenado(),
          _teclado(context),
        ],
      ),
    );
  }

  Expanded _listaProductoOrdenado(context) {
    return Expanded(
      child: mostrarIdentificador
          ? Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      if (value.isNotEmpty) {
                        onTextIdentificadorTap(value);
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: 'Identificador de Venta'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          onBackIdentificador();
                        },
                        child: const Text('Volver')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Theme.of(context).canvasColor),
                        onPressed: () {
                          onAceptarIdentificador();
                        },
                        child: const Text('Aceptar'))
                  ],
                )
              ],
            )
          : ListView.builder(
              itemCount: productosAgregados.length,
              itemBuilder: (BuildContext context, int index) {
                final ProductoPreOrdenado? producto = productosAgregados[index];
                final double total =
                    double.parse(producto!.cantidad) * producto.precio;

                return Slidable(
                  key: UniqueKey(),
                  startActionPane: ActionPane(
                      extentRatio: 0.85,
                      motion: const ScrollMotion(),
                      openThreshold: 0.25,
                      children: [
                        SlidableAction(
                            onPressed: (context) {},
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .secondaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                            icon: Icons.movie_edit,
                            label: 'Precio'),
                        SlidableAction(
                            onPressed: (context) {},
                            backgroundColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            icon: Icons.delete,
                            label: 'Eliminar'),
                        SlidableAction(
                            onPressed: (context) {},
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            icon: Icons.onetwothree_rounded,
                            label: 'Unidades'),
                      ]),
                  child: Builder(builder: (context) {
                    return ListTile(
                      onTap: () {
                        final slide = Slidable.of(context);
                        slide!.openStartActionPane();
                      },
                      selected: selectedItemLista.value == index ? true : false,
                      selectedTileColor: ThemeData().focusColor,
                      visualDensity: VisualDensity.compact,
                      title: Text(producto.nombreProducto),
                      subtitle:
                          Text('${producto.cantidad} x ${producto.precio}€'),
                      trailing: Text('${total.toString()}€'),
                    );
                  }),
                );
              },
            ),
    );
  }

  Visibility _totalVenta() {
    return Visibility(
      visible:
          productosAgregados.isEmpty || mostrarIdentificador ? false : true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
                icon: const Icon(Icons.clear_all_rounded),
                onPressed: () {
                  clearButton();
                },
                label: const Text('Limpiar Lista')),
            Text(totalVenta != 0.0 ? '€ ${totalVenta.toString()}' : '')
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> _elementoPreOrdenado() {
    return FutureBuilder(
        future: actualizarCantidad,
        builder: (context, snapshot) {
          return ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: showTeclado
                  ? const Radius.circular(0)
                  : const Radius.circular(20),
            ),
            child: Container(
                color: const Color.fromARGB(50, 54, 54, 54),
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment:
                        productoPreOrdenado.nombreProducto.isEmpty
                            ? MainAxisAlignment.spaceAround
                            : MainAxisAlignment.spaceBetween,
                    children: [
                      Text(productoPreOrdenado.nombreProducto),
                      Text(productoPreOrdenado.cantidad),
                      Text(productoPreOrdenado.precio != 0
                          ? '€ ${productoPreOrdenado.precio.toString()}'
                          : ''),
                      GestureDetector(
                          onTap: () {
                            dropDownIcon();
                          },
                          child: Icon(showTeclado
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up)),
                    ],
                  ),
                )),
          );
        });
  }

  Widget _teclado(BuildContext context) {
    final ratio = menuPrincipal ? 0.3 : 0.39;
    final height = MediaQuery.of(context).size.height * 0.2;
    final width = MediaQuery.of(context).size.width * ratio;
    return Visibility(
      visible: showTeclado,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: height,
                width: width,
                child: GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    mainAxisExtent: height / 3,
                  ),
                  clipBehavior: Clip.antiAlias,
                  children: [
                    _itemNumeroTeclado('1'),
                    _itemNumeroTeclado('2'),
                    _itemNumeroTeclado('3'),
                    _itemNumeroTeclado('4'),
                    _itemNumeroTeclado('5'),
                    _itemNumeroTeclado('6'),
                    _itemNumeroTeclado('7'),
                    _itemNumeroTeclado('8'),
                    _itemNumeroTeclado('9'),
                  ],
                ),
              ),
              Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20)),
                    child: SizedBox(
                      height: height / 3,
                      width: width / 3,
                      child: GestureDetector(
                        onTap: () => addAction(cantidad),
                        child: _itemActionTeclado(
                          Icons.add,
                          ThemeData().primaryColor.withOpacity(0.5),
                          Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                      height: height / 3,
                      width: width / 3,
                      child: _itemNumeroTeclado('0')),
                  GestureDetector(
                    onTap: () => backspace(cantidad),
                    child: SizedBox(
                      height: height / 3,
                      width: width / 3,
                      child: _itemActionTeclado(
                        Icons.backspace_outlined,
                        ThemeData().highlightColor,
                        Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: menuPrincipal ? true : false,
            child: Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.only(bottomRight: Radius.circular(20)),
                child: SizedBox(
                  height: height + height / 3,
                  child: GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                          barrierColor: const Color.fromARGB(29, 0, 0, 0),
                          context: context,
                          builder: (context) {
                            return const ActionButton();
                          });
                    },
                    child: _itemActionTeclado(
                      Icons.view_agenda_outlined,
                      ThemeData().primaryColor,
                      Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemNumeroTeclado(String label) {
    return GestureDetector(
        onTap: () => onTapNum(label),
        child: containerTeclado(
            Text(
              label,
              style: const TextStyle(
                  fontSize: 16.5,
                  color: Color.fromARGB(255, 65, 65, 65),
                  shadows: [
                    Shadow(
                      color: Color.fromARGB(
                          38, 20, 6, 41), // Choose the color of the shadow
                      blurRadius:
                          5.0, // Adjust the blur radius for the shadow effect
                      offset: Offset(1.0,
                          1.0), // Set the horizontal and vertical offset for the shadow
                    ),
                  ]),
            ),
            const Color.fromARGB(115, 235, 235, 235)));
  }

  Widget _itemActionTeclado(IconData icon, Color color, Color colorIcon) {
    return containerTeclado(
      Icon(
        icon,
        color: colorIcon,
      ),
      color,
    );
  }

  Container containerTeclado(Widget element, Color color) {
    return Container(
        decoration: BoxDecoration(
            color: color,
            border: Border.all(
                color: const Color.fromARGB(59, 7, 7, 7), width: 0.15)),
        child: Center(child: element));
  }
}

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(28, 0, 0, 0),
            offset: Offset(0, -5),
            blurRadius: 45,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        color: Colors.grey[300],
      ),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.175,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/cliente');
                },
                icon: const Icon(Icons.groups_rounded),
                label: const Text('Cliente')),
            ElevatedButton.icon(
                onPressed: () {
                  popNamed(context, '/consumicion');
                },
                icon: const Icon(Icons.dinner_dining_outlined),
                label: const Text('Consumicion Propia')),
            ElevatedButton.icon(
                onPressed: () {
                  popNamed(context, '/ticket_diario');
                },
                icon: const Icon(Icons.calendar_today_rounded),
                label: const Text('Ticket Diario')),
            ElevatedButton.icon(
                onPressed: () {
                  popNamed(context, '/espera');
                },
                icon: const Icon(Icons.list_alt_rounded),
                label: const Text('Venta en Espera')),
            ElevatedButton.icon(
                onPressed: () {
                  popNamed(context, '/devolucion');
                },
                icon: const Icon(Icons.replay_circle_filled_outlined),
                label: const Text('Devolucion')),
            ElevatedButton.icon(
                onPressed: () {
                  popNamed(context, '/cierre_diario');
                },
                icon: const Icon(Icons.account_balance_outlined),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.tertiaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onTertiaryContainer),
                label: const Text('Cierre Diario')),
          ],
        ),
      ),
    );
  }

  void popNamed(BuildContext context, String routeName) {
    Navigator.popAndPushNamed(context, routeName);
  }
}
