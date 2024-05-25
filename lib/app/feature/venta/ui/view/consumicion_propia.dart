import 'package:flutter/material.dart';

import '../widgets/menu.dart';

class ConsumicionPropia extends StatelessWidget {
  const ConsumicionPropia({super.key});
  static const routeName = '/consumicion';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Menu(
      false,
      menuPrincipal: false,
      titleSection: 'Consumicion Propia',
    ));
  }
}
