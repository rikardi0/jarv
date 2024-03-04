import 'package:flutter/material.dart';

class CardButton extends StatelessWidget {
  const CardButton({
    super.key,
    required this.content,
    required this.valueNotifier,
    required this.colorSelected,
    required this.posicion,
  });

  final ValueNotifier<int?> valueNotifier;
  final String content;
  final int posicion;
  final Color colorSelected;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: valueNotifier.value != posicion
          ? Theme.of(context).cardTheme.color
          : Colors.transparent,
      elevation: valueNotifier.value != posicion
          ? Theme.of(context).cardTheme.elevation
          : 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
              color: valueNotifier.value == posicion
                  ? colorSelected
                  : Colors.transparent)),
      child: ListTile(
          title: Text(
        content,
        style: TextStyle(
            color: valueNotifier.value == posicion
                ? colorSelected
                : Theme.of(context).listTileTheme.textColor),
      )),
    );
  }
}
