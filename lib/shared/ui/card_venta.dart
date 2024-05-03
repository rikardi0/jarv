import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/ui/utils/date_format.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            isThreeLine: true,
            titleAlignment: ListTileTitleAlignment.center,
            onTap: () {
              action(index);
            },
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(fechaFormatter(
                    listaProductos[index].listaProducto.first!.fecha)),
                Text(hourFormatter(
                    listaProductos[index].listaProducto.first!.fecha)),
              ],
            ),
            leading: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 25.0),
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
        ),
      ),
    );
  }
}
