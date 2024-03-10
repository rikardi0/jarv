import 'package:flutter/material.dart';
import 'package:jarv/src/widgets/menu/menu.dart';

import '../../data_source/db.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen(
      {super.key,
      required this.familia,
      required this.subFamilia,
      required this.producto});
  final FamiliaDao familia;
  final SubFamiliaDao subFamilia;
  final ProductoDao producto;
  static const routeName = "/menu";

  @override
  Widget build(BuildContext context) {
    return Menu(
        familia: familia,
        subFamilia: subFamilia,
        producto: producto,
        menuPrincipal: true);
  }
}
