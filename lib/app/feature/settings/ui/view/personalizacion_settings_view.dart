import 'package:flutter/material.dart';
import 'package:jarv/app/feature/settings/ui/provider/settings_controller.dart';
import 'package:jarv/app/feature/settings/ui/widget/setting_list_tile.dart';

class PersonalizacionSettingsView extends StatefulWidget {
  const PersonalizacionSettingsView({Key? key, required this.controller})
      : super(key: key);
  static const routeName = '/personalizacion_settings';
  final SettingsController controller;

  @override
  State<PersonalizacionSettingsView> createState() =>
      _PersonalizacionSettingsViewState();
}

class _PersonalizacionSettingsViewState
    extends State<PersonalizacionSettingsView> {
  double sliderValue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Personalizacion'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: containerCard(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: const Card(),
                  ),
                )
              ],
            ),
            rowButton()
          ],
        ));
  }

  Widget rowButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilledButton.tonal(
                    onPressed: () {}, child: const Text('Cancelar')),
                FilledButton(
                    onPressed: () {}, child: const Text('Predeterminado')),
              ],
            ),
          ),
          ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.save),
              label: const Text('Guardar')),
        ],
      ),
    );
  }

  Widget containerCard(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pantallaSettings(context),
          accesibilidadSettings(context),
        ],
      ),
    );
  }

  Widget pantallaSettings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Text(
                'Pantalla',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SettingsListTile(title: 'Fondo Pantalla'),
          ],
        ),
      ),
    );
  }

  Card accesibilidadSettings(BuildContext context) {
    return Card(
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Text(
              'Accesibilidad',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          darkModeSwitch(context),
          SettingsListTile(
            title: 'Tamaño Letra',
            trailing: Icon(
              Icons.format_size_outlined,
              size: sliderValue == 0
                  ? 25
                  : sliderValue == 1.5
                      ? 30
                      : 35,
            ),
          ),
          sliderFontSize()
        ],
      ),
    );
  }

  Padding sliderFontSize() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Slider(
        value: sliderValue,
        min: 0,
        max: 3,
        divisions: 2,
        label: sliderValue == 0
            ? 'Pequeno'
            : sliderValue == 1.5
                ? 'Mediano'
                : 'Grande',
        onChanged: (double value) {
          setState(() {
            sliderValue = value;
          });
        },
      ),
    );
  }

  Widget darkModeSwitch(BuildContext context) {
    return SettingsListTile(
      title: 'Modo Oscuro',
      trailing: FittedBox(
        child: Row(
          children: [
            Text(
              widget.controller.themeMode == ThemeMode.dark
                  ? 'Activado'
                  : 'Desactivado',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Switch(
                value: widget.controller.themeMode == ThemeMode.dark
                    ? true
                    : false,
                onChanged: (value) {
                  changeTheme();
                })
          ],
        ),
      ),
    );
  }

  void changeTheme() {
    if (widget.controller.themeMode == ThemeMode.light) {
      widget.controller.updateThemeMode(ThemeMode.dark);
    } else {
      widget.controller.updateThemeMode(ThemeMode.light);
    }
  }
}
