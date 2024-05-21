import 'package:flutter/material.dart';
import 'package:jarv/shared/ui/widget/card_button.dart';

import '../../data/model/entity.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView.builder(
        clipBehavior: Clip.none,
        physics: const BouncingScrollPhysics(),
        itemCount: itemFamilia?.length,
        itemBuilder: (context, index) {
          Familia? familia = itemFamilia![index];
          return GestureDetector(
            onTap: () => onFamiliaTap(familia, index),
            child: CardButton(
              valueNotifier: selectedFamiliaIndex,
              colorSelected: ThemeData().colorScheme.onPrimary,
              content: familia.nombreFamilia,
              posicion: index,
            ),
          );
        },
      ),
    );
  }
}
