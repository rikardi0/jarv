import 'package:flutter/material.dart';
import 'package:jarv/shared/ui/utils/validators.dart';

class ClienteSelector extends StatelessWidget {
  const ClienteSelector({
    super.key,
    required this.cliente,
    required this.clienteLista,
    required this.onChanged,
  });

  final String? cliente;
  final Stream<List<String>> clienteLista;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: clienteLista,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButtonFormField<String>(
            validator: (value) {
              if (value == null) {
                return emptyValidator(value!);
              }
              return null;
            },
            isExpanded: true,
            hint: const Text('Nombre Cliente'),
            value: cliente,
            items: snapshot.data!
                .map((value) => DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    ))
                .toList(),
            onChanged: (value) {
              onChanged(value);
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
