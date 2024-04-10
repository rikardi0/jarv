import 'package:flutter/material.dart';

import '../../app/feature/venta/data/model/entity_venta.dart';

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
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: itemSubFamilia?.length ?? 0,
      itemBuilder: (context, index) {
        SubFamilia? subFamilia = itemSubFamilia![index];
        return GestureDetector(
            onTap: () => onSubFamiliaTap(subFamilia, index),
            child: Container(
                color: Colors.transparent,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subFamilia!.nombreSub,
                      style: TextStyle(
                        color: selectedSubFamiliaIndex.value == index
                            ? Theme.of(context).colorScheme.primary
                            : Colors.black,
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
                      ),
                    ),
                    Divider(
                      color: selectedSubFamiliaIndex.value == index
                          ? Theme.of(context).colorScheme.primary
                          : Colors.black,
                    )
                  ],
                )));
      },
    );
  }
}
