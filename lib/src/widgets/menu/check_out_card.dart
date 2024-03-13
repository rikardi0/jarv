import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jarv/src/utils/models/producto_ordenado.dart';

class CheckOut extends StatelessWidget {
  const CheckOut(
      {super.key,
      required this.mostrarIdentificador,
      required this.productosAgregados,
      required this.totalVenta,
      required this.cantidadProducto,
      required this.actualizarCantidad,
      this.onTextIdentificadorTap,
      this.onBackIdentificador,
      this.onAceptarIdentificador,
      this.clearButton,
      this.onTapNum,
      required this.showTeclado,
      this.dropDownIcon,
      required this.selectedItemLista,
      required this.menuPrincipal});

  final bool mostrarIdentificador;
  final bool showTeclado;
  final bool menuPrincipal;
  final List<ProductoOrdenado?> productosAgregados;
  final double totalVenta;
  final String cantidadProducto;
  final Future<void> actualizarCantidad;
  final ValueNotifier<int?> selectedItemLista;
  final dynamic onTextIdentificadorTap;
  final dynamic onBackIdentificador;
  final dynamic onAceptarIdentificador;
  final dynamic clearButton;
  final dynamic onTapNum;
  final dynamic dropDownIcon;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: BorderSide(
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.15)),
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(20))),
      elevation: 0.5,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _listaProductoOrdenado(context),
          _totalVenta(),
          _displayCantidad(),
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
                final ProductoOrdenado? producto = productosAgregados[index];
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

  FutureBuilder<void> _displayCantidad() {
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cantidadProducto),
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
    final ratio = menuPrincipal ? 0.15 : 0.3;
    final height = MediaQuery.of(context).size.height * 0.275;
    final width = MediaQuery.of(context).size.width * ratio;
    final colorScheme = Theme.of(context).colorScheme;
    var totalHeight = height + height / 3;
    return Visibility(
      visible: showTeclado,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      mainAxisSpacing: 1,
                      crossAxisSpacing: 0,
                      mainAxisExtent: height / 3.1,
                    ),
                    clipBehavior: Clip.antiAlias,
                    children: [
                      _itemNumeroTeclado('1', context),
                      _itemNumeroTeclado('2', context),
                      _itemNumeroTeclado('3', context),
                      _itemNumeroTeclado('4', context),
                      _itemNumeroTeclado('5', context),
                      _itemNumeroTeclado('6', context),
                      _itemNumeroTeclado('7', context),
                      _itemNumeroTeclado('8', context),
                      _itemNumeroTeclado('9', context),
                    ],
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => onTapNum('0'),
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                        child: Container(
                            color: Theme.of(context)
                                .colorScheme
                                .outline
                                .withOpacity(0.75),
                            height: height / 3,
                            width: width / 1.5,
                            child: const Center(
                                child: Text(
                              '0',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ))),
                      ),
                    ),
                    SizedBox(
                      height: height / 3,
                      width: width / 3,
                      child: _itemNumeroTeclado(',', context),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: totalHeight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _itemActionTeclado(
                    context,
                    height,
                    width,
                    'Devolucion',
                    Icons.change_circle_outlined,
                    colorScheme.onPrimaryContainer,
                  ),
                  _itemActionTeclado(
                    context,
                    height,
                    width,
                    'Cliente',
                    Icons.group,
                    colorScheme.primary,
                  ),
                  _itemActionTeclado(
                    context,
                    height,
                    width,
                    'Consumicion',
                    Icons.dinner_dining,
                    colorScheme.secondary,
                  ),
                  _itemActionTeclado(
                    context,
                    height,
                    width,
                    'Ticket Diario',
                    Icons.change_circle_outlined,
                    colorScheme.tertiary,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Container _itemActionTeclado(BuildContext context, double height,
      double width, String label, IconData icon, Color colorIcon) {
    return Container(
      decoration: ShapeDecoration(
          color: Theme.of(context).colorScheme.surface,
          shape: StadiumBorder(
              side: BorderSide(
            color: Theme.of(context).colorScheme.surfaceVariant,
          ))),
      height: height / 3.5,
      width: width / 1.25,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: AlignmentDirectional.centerStart,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Row(
            children: [
              Icon(
                icon,
                color: colorIcon,
              ),
              Text(
                label,
                style: TextStyle(color: colorIcon),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemNumeroTeclado(String label, context) {
    return GestureDetector(
        onTap: () => onTapNum(label),
        child: containerTeclado(
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Theme.of(context).colorScheme.outline.withOpacity(0.25),
        ));
  }

  Widget containerTeclado(Widget element, Color color) {
    return Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
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
