import 'package:flutter/material.dart';

import '../../data_source/db.dart';
import '../../widgets/menu/menu.dart';

class ConsumicionPropia extends StatelessWidget {
  ConsumicionPropia(
      {super.key,
      required this.familia,
      required this.subFamilia,
      required this.producto});
  static const routeName = '/consumicion';

  final FamiliaDao familia;
  final SubFamiliaDao subFamilia;
  final ProductoDao producto;

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);
  final selectedItemLista = ValueNotifier<int?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Menu(
      familia: familia,
      subFamilia: subFamilia,
      producto: producto,
      menuPrincipal: false,
    ));
  }
}
