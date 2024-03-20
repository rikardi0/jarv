import 'package:flutter/material.dart';

class MetodoPagoSelector extends StatelessWidget {
  const MetodoPagoSelector({
    super.key,
    required this.metodoPago,
    required this.onChanged,
  });

  final String metodoPago;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        isExpanded: true,
        icon: Icon(
            metodoPago == 'tarjeta' ? Icons.payment : Icons.payments_outlined),
        value: metodoPago,
        items: const <DropdownMenuItem>[
          DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
          DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
        ],
        onChanged: (value) {
          onChanged(value);
        });
  }
}
