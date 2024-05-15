import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.info_outline),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Sin ventas Registradas',
                style: TextStyle(fontSize: 20, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
