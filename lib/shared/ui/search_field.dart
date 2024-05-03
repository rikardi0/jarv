import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.label,
    required this.type,
    required this.controller,
    this.onChanged,
  });
  final String label;
  final TextInputType type;
  final TextEditingController controller;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: TextField(
        controller: controller,
        onChanged: (value) {
          onChanged(value);
        },
        keyboardType: type,
        decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0))),
          labelText: label,
          suffixIcon: const Icon(Icons.search),
        ),
      ),
    );
  }
}
