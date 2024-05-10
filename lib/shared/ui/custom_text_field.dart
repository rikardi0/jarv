import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/ui/utils/validators.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
    required this.keyboard,
    this.validateAction,
  });

  final String label;
  final String value;
  final TextEditingController controller;
  final TextInputType keyboard;
  final dynamic validateAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: TextFormField(
        validator: (value) {
          if (value!.isEmpty) {
            return '$emptyMessage $label';
          }
          return validateAction(value);
        },
        keyboardType: keyboard,
        controller: controller,
        decoration: InputDecoration(
          label: Text(label),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
      ),
    );
  }
}
