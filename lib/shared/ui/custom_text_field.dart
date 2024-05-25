import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
    required this.keyboard,
  });

  final String label;
  final String value;
  final TextEditingController controller;
  final TextInputType keyboard;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: TextFormField(
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
