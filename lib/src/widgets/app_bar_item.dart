import 'package:flutter/material.dart';

class AppBarItemButton extends StatelessWidget {
  const AppBarItemButton({
    super.key,
    required this.icon,
    required this.label,
    this.routeName,
  });

  final IconData icon;
  final String label;
  final String? routeName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon),
          const SizedBox(
            width: 5.0,
          ),
          Text(
            label,
          )
        ],
      ),
    );
  }
}
