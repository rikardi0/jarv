import 'package:flutter/material.dart';

class SettingsListTile extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SettingsListTile({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      selectedTileColor: Theme.of(context).colorScheme.outlineVariant,
      shape: Border(
        top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          title,
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleMedium!.fontSize),
        ),
      ),
      trailing: trailing,
    );
  }
}
