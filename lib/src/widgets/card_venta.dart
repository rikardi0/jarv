import 'package:flutter/material.dart';

import '../utils/models/producto_ordenado.dart';

class CardVenta extends StatelessWidget {
  final int index;
  final ValueNotifier<int?> selected;
  final List<ProductoOrdenado> listaProductos;
  final Color color;
  final dynamic action;

  const CardVenta({
    Key? key,
    required this.index,
    required this.selected,
    required this.listaProductos,
    required this.color,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: selected.value != index
          ? Theme.of(context).cardTheme.color
          : Colors.transparent,
      elevation:
          selected.value != index ? Theme.of(context).cardTheme.elevation : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
            color: selected.value == index ? color : Colors.transparent),
      ),
      child: ListTile(
        onTap: () {
          action(index);
        },
        leading: Text(listaProductos[index].identificadorVenta!),
        subtitle: Text('${listaProductos[index].totalVenta.toString()} €'),
        title: Text(
          'Productos: ${listaProductos[index].listaProducto.length.toString()}',
          style: TextStyle(
            color: selected.value == index
                ? color
                : Theme.of(context).listTileTheme.textColor,
          ),
        ),
      ),
    );
  }
}
