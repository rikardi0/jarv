import 'package:flutter/material.dart';

import '../utils/models/producto_espera.dart';

class CardVenta extends StatelessWidget {
  final int index;
  final ValueNotifier<int?> selected;
  final List<ProductoEspera> listaProductoEspera;
  final Color color;
  final dynamic action;

  const CardVenta({
    Key? key,
    required this.index,
    required this.selected,
    required this.listaProductoEspera,
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
        leading: Text(listaProductoEspera[index].identificadorVenta!),
        subtitle: Text('${listaProductoEspera[index].totalVenta.toString()} €'),
        title: Text(
          'Productos: ${listaProductoEspera[index].listaProducto.length.toString()}',
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
