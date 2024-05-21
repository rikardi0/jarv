import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog({
    super.key,
    required this.context,
    required this.content,
  });

  final BuildContext context;
  final String content;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Theme.of(context).colorScheme.primary)),
      content: ListTile(
          leading: Lottie.asset(
            "assets/animation/check_animated.json",
            height: 50,
            width: 50,
          ),
          title: Text(
            'Atencion!',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          subtitle: Text(
            content,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          )),
    );
  }
}
