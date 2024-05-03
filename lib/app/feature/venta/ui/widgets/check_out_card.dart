import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:jarv/app/feature/venta/data/model/producto_ordenado.dart';

class CheckOut extends StatelessWidget {
  const CheckOut({
    super.key,
    required this.mostrarIdentificador,
    required this.productosAgregados,
    required this.totalVenta,
    required this.cantidadProducto,
    required this.actualizarCantidad,
    required this.mostrarTeclado,
    required this.selectedItemLista,
    required this.isMenuPrincipal,
    required this.titleSection,
    this.onTextIdentificadorTap,
    this.onBackIdentificador,
    this.onAceptarIdentificador,
    this.sectionActionButton,
    this.onTapNum,
    this.clearButton,
    this.hideKeyboard,
  });

  final String cantidadProducto;
  final bool mostrarIdentificador;
  final bool mostrarTeclado;
  final bool isMenuPrincipal;
  final List<ProductoOrdenado?> productosAgregados;
  final double totalVenta;
  final Future<void> actualizarCantidad;
  final ValueNotifier<int?> selectedItemLista;
  final String titleSection;
  final dynamic onTextIdentificadorTap;
  final dynamic onBackIdentificador;
  final dynamic onAceptarIdentificador;
  final dynamic clearButton;
  final dynamic onTapNum;
  final dynamic hideKeyboard;
  final dynamic sectionActionButton;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .onBackground
                    .withOpacity(0.15)),
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
      ),
    );
  }

  Expanded _listaProductoOrdenado(context) {
    return Expanded(
      child: mostrarIdentificador
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 5.0),
                  child: TextFormField(
                    onChanged: (value) {
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
              bottom: mostrarTeclado
                  ? const Radius.circular(0)
                  : const Radius.circular(20),
            ),
            child: Container(
                color: cantidadProducto.isEmpty
                    ? const Color.fromARGB(50, 54, 54, 54)
                    : Theme.of(context).colorScheme.primaryContainer,
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(cantidadProducto.isNotEmpty
                          ? 'Cantidad: $cantidadProducto'
                          : ''),
                      GestureDetector(
                          onTap: () {
                            hideKeyboard();
                          },
                          child: Icon(mostrarTeclado
                              ? Icons.arrow_drop_down
                              : Icons.arrow_drop_up)),
                    ],
                  ),
                )),
          );
        });
  }

  Widget _teclado(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.22;
    final width = MediaQuery.of(context).size.width * 0.15;
    final colorScheme = Theme.of(context).colorScheme;
    var totalHeight = height + height / 4;
    return Visibility(
      visible: mostrarTeclado,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                            const BorderRadius.all(Radius.circular(25)),
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
            isMenuPrincipal
                ? _buildColumnAction(
                    totalHeight, context, height, width, colorScheme)
                : _buildActionButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          sectionActionButton();
        },
        child: Container(
          decoration: BoxDecoration(
              color: productosAgregados.isEmpty
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).colorScheme.primary,
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(20))),
          height: MediaQuery.of(context).size.height * 0.375,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_box,
                size: 40,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              Text(
                titleSection,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildColumnAction(double totalHeight, BuildContext context,
      double height, double width, ColorScheme colorScheme) {
    return SizedBox(
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
            '/devolucion',
          ),
          _itemActionTeclado(
            context,
            height,
            width,
            'Consumicion',
            Icons.dinner_dining,
            colorScheme.secondary,
            '/consumicion',
          ),
          _itemActionTeclado(
            context,
            height,
            width,
            'Ticket Diario',
            Icons.change_circle_outlined,
            colorScheme.tertiary,
            '/ticket_diario',
          ),
          _itemActionTeclado(
            context,
            height,
            width,
            'Cliente',
            Icons.group,
            colorScheme.primary,
            '/cliente',
          ),
        ],
      ),
    );
  }

  Widget _itemActionTeclado(BuildContext context, double height, double width,
      String label, IconData icon, Color colorIcon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.surface,
            shape: StadiumBorder(
                side: BorderSide(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ))),
        height: height / 3.5,
        width: width / 1.25,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.5),
          child: Row(
            children: [
              Icon(
                icon,
                size: Theme.of(context).textTheme.headlineLarge!.fontSize,
                color: colorIcon,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  label,
                  style: TextStyle(
                    color: colorIcon,
                    fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  ),
                ),
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
