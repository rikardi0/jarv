import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Sin ventas Registradas',
                style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                    color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
