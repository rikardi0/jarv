import 'package:flutter/material.dart';
import 'package:jarv/src/data_source/db.dart';
import 'package:jarv/src/widgets/card_button.dart';

class RowSubFamilia extends StatelessWidget {
  const RowSubFamilia({
    super.key,
    required this.selectedSubFamiliaIndex,
    required this.itemSubFamilia,
    this.onSubFamiliaTap,
  });

  final ValueNotifier<int?> selectedSubFamiliaIndex;
  final List<SubFamilia?>? itemSubFamilia;
  final dynamic onSubFamiliaTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.17,
      width: size.width * 0.45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemSubFamilia?.length ?? 0,
        itemBuilder: (context, index) {
          SubFamilia? subFamilia = itemSubFamilia![index];
          return GestureDetector(
              onTap: () => onSubFamiliaTap(subFamilia, index),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
                child: CardButton(
                    content: subFamilia!.nombreSub,
                    valueNotifier: selectedSubFamiliaIndex,
                    colorSelected: Colors.deepPurpleAccent,
                    posicion: index),
              ));
        },
      ),
    );
  }
}
