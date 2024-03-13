import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Menu(
                familia: familia,
                subFamilia: subFamilia,
                producto: producto,
                menuPrincipal: true),
          ),
          const BottomActions()
        ],
      ),
    );
  }
}

class BottomActions extends StatelessWidget {
  const BottomActions({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.16,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/cierre_diario');
                },
                icon: const Icon(Icons.account_balance_outlined),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.secondaryContainer,
                    foregroundColor:
                        Theme.of(context).colorScheme.onSecondaryContainer),
                label: const Text('Cierre Diario')),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/espera');
              },
              icon: const Icon(Icons.list_alt_rounded),
              label: const Text('Venta en Espera'),
            )
          ],
        ),
      ),
    );
  }
}
