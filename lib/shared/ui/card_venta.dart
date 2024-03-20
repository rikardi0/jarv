import 'package:flutter/material.dart';

import '../../../app/feature/venta/data/model/producto_espera.dart';

class CardVenta extends StatelessWidget {
  final int index;
  final ValueNotifier<int?> selected;
  final List<ProductoEspera> listaProductos;
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
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(
            color: selected.value == index ? color : Colors.transparent),
      ),
      child: ListTile(
        visualDensity: VisualDensity.compact,
        isThreeLine: true,
        titleAlignment: ListTileTitleAlignment.center,
        onTap: () {
          action(index);
        },
        trailing: const Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('16 Diciembre'),
            Text('15:31'),
          ],
        ),
        leading: Container(
            decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).colorScheme.outline),
                borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25.0),
              child: Text(
                listaProductos[index].identificadorVenta!.toUpperCase(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            )),
        subtitle: Text('${listaProductos[index].totalVenta.toString()} €'),
        title: Text(
          'Total',
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
