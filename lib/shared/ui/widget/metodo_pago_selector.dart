import 'package:flutter/material.dart';
import 'package:jarv/shared/ui/utils/validators.dart';

class MetodoPagoSelector extends StatelessWidget {
  const MetodoPagoSelector({
    super.key,
    required this.metodoPago,
    required this.onChanged,
    this.onCancel,
  });

  final String? metodoPago;
  final dynamic onChanged;
  final dynamic onCancel;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
        validator: (value) {
          if (value == null) {
            return emptyMessage;
          }
          return null;
        },
        hint: const Text('Metodo de Pago'),
        isExpanded: true,
        icon: metodoPago == null
            ? const Icon(Icons.arrow_drop_down)
            : GestureDetector(
                onTap: () {
                  onCancel();
                },
                child: const Icon(Icons.cancel_outlined),
              ),
        value: metodoPago,
        items: const <DropdownMenuItem<String>>[
          DropdownMenuItem(value: 'efectivo', child: Text('Efectivo')),
          DropdownMenuItem(value: 'tarjeta', child: Text('Tarjeta')),
        ],
        onChanged: (value) {
          onChanged(value);
        });
  }
}
