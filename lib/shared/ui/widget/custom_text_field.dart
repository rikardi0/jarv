import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
    required this.keyboard,
    this.validateAction,
    this.obscureText,
    this.trailing,
  });

  final String label;
  final String value;
  final TextEditingController controller;
  final TextInputType keyboard;
  final bool? obscureText;
  final dynamic validateAction;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      child: TextFormField(
        obscureText: obscureText != null ? true : false,
        validator: (value) {
          if (value!.isEmpty) {
            return validateAction(value);
          }
          return null;
        },
        keyboardType: keyboard,
        controller: controller,
        decoration: InputDecoration(
          suffixIcon: trailing,
          label: Text(label),
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
        ),
      ),
    );
  }
}
