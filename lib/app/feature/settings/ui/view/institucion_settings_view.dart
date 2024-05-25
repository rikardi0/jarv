import 'package:flutter/material.dart';

class InstitucionSettingsView extends StatefulWidget {
  const InstitucionSettingsView({super.key});

  static const routeName = '/institucion_settings';

  @override
  State<InstitucionSettingsView> createState() =>
      _InstitucionSettingsViewState();
}

class _InstitucionSettingsViewState extends State<InstitucionSettingsView> {
  final ValueNotifier<int?> selectedItem = ValueNotifier<int?>(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Institucion'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 50),
        child: Row(
          children: [
            buildTitle(selectedItem, context, 0, 'Empresa'),
            buildTitle(selectedItem, context, 1, 'Tienda'),
          ],
        ),
      ),
    );
  }

  GestureDetector buildTitle(ValueNotifier<int?> selectedItem,
      BuildContext context, int position, String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedItem.value = position;
        });
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                fontWeight:
                    selectedItem.value == position ? FontWeight.bold : null,
              ),
            ),
            Divider(
              color: selectedItem.value == position
                  ? Theme.of(context).colorScheme.primary
                  : null,
              thickness: selectedItem.value == position ? 3 : 0.5,
            )
          ],
        ),
      ),
    );
  }

  Widget buildItemSelector(
    BuildContext context,
    label,
  ) {
    return GestureDetector(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.25,
        child: Column(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Divider(
              thickness: 2.5,
            )
          ],
        ),
      ),
    );
  }
}
