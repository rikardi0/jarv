import 'package:flutter/material.dart';
import 'package:jarv/src/data_source/db.dart';
import 'package:jarv/src/widgets/card_button.dart';

class ListFamilia extends StatelessWidget {
  const ListFamilia({
    super.key,
    required this.selectedFamiliaIndex,
    required this.itemFamilia,
    this.onFamiliaTap,
  });

  final ValueNotifier<int?> selectedFamiliaIndex;
  final List<Familia>? itemFamilia;
  final dynamic onFamiliaTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.15,
      child: ListView.builder(
        itemCount: itemFamilia?.length,
        itemBuilder: (context, index) {
          Familia? familia = itemFamilia![index];
          return GestureDetector(
            onTap: () => onFamiliaTap(familia, index),
            child: CardButton(
              valueNotifier: selectedFamiliaIndex,
              colorSelected: Colors.black,
              content: familia.nombreFamilia,
              posicion: index,
            ),
          );
        },
      ),
    );
  }
}