import 'package:flutter/material.dart';

import '../widgets/menu.dart';

class ConsumicionPropia extends StatelessWidget {
  ConsumicionPropia({super.key});
  static const routeName = '/consumicion';

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);
  final selectedItemLista = ValueNotifier<int?>(null);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Menu(
      menuPrincipal: false,
    ));
  }
}
