import 'package:flutter/material.dart';
import 'package:jarv/shared/ui/utils/validators.dart';

class MedidaSelector extends StatelessWidget {
  const MedidaSelector({super.key, required this.onChanged});

  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButtonFormField<String>(
          validator: (value) {
            if (value == null) {
              return emptyValidator(value!);
            }
            return null;
          },
          hint: const Text('Medida'),
          isExpanded: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
          ),
          items: const <DropdownMenuItem<String>>[
            DropdownMenuItem(value: 'g.', child: Text('Gramos')),
            DropdownMenuItem(value: 'kg.', child: Text('Kilogramo')),
            DropdownMenuItem(value: 'ud.', child: Text('Unidad')),
            DropdownMenuItem(value: 'lts.', child: Text('Litro')),
            DropdownMenuItem(value: 'ml.', child: Text('Mililitros')),
          ],
          onChanged: (value) {
            onChanged(value);
          }),
    );
  }
}
