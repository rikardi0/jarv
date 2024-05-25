import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/ui/widgets/menu.dart';

class Devolucion extends StatelessWidget {
  const Devolucion({super.key});
  static const routeName = '/devolucion';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Menu(
        true,
        menuPrincipal: false,
        titleSection: 'Devolucion',
      ),
    );
  }
}
