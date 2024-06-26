import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/ui/widgets/menu.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({
    super.key,
  });
  static const routeName = "/menu";

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Menu(
              false,
              menuPrincipal: true,
              titleSection: 'Menu Principal',
            ),
          ),
          BottomActions()
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5.0),
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
    );
  }
}
