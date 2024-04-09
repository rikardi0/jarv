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
      body: Menu(),
    );
  }
}
