import 'package:flutter/material.dart';
import 'package:jarv/shared/data/database.dart';

import '../widgets/menu.dart';

class ConsumicionPropia extends StatelessWidget {
  ConsumicionPropia({super.key, required this.database});
  final AppDatabase database;
  static const routeName = '/consumicion';

  final selectedFamiliaIndex = ValueNotifier<int?>(null);
  final selectedSubFamiliaIndex = ValueNotifier<int?>(null);
  final selectedProductoIndex = ValueNotifier<int?>(null);
  final selectedItemLista = ValueNotifier<int?>(null);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Menu(
      menuPrincipal: false,
      db: database,
    ));
  }
}
