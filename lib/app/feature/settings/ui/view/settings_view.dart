import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:jarv/app/feature/settings/ui/provider/settings_controller.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';
  final SettingsController controller;

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isSwitchActive = false;

  final Map<String, IconData> settingsMap = {
    'Empresa': Icons.store,
    'Tienda': Icons.storefront_rounded,
    'Personalización': Icons.edit,
    'Dispositivos': Icons.devices,
    'Ventas': Icons.sell,
    'Time-Out': Icons.access_time, // Corrected icon for Time-Out
    'Exportar': Icons.import_export,
  };

  @override
  Widget build(BuildContext context) {
    isSwitchActive =
        widget.controller.themeMode == ThemeMode.light ? false : true;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuracion'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildListSettings(context),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoTienda(context, 'Nombre Tienda'),
                  buildContainer(context),
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildInfoTienda(BuildContext context, String title) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 100,
          width: 100,
          color: Colors.blue,
        ),
        SizedBox(
          width: 400,
          child: ListTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            subtitle: Text(
              'editar',
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                width: 1.25,
                color: Theme.of(context).colorScheme.outline.withOpacity(0.5))),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Configuracion',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          'Modo oscuro',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Text(
                        isSwitchActive ? 'Activado' : 'Desactivado',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Switch(
                          value: isSwitchActive,
                          onChanged: (value) {
                            if (widget.controller.themeMode ==
                                ThemeMode.light) {
                              widget.controller.updateThemeMode(ThemeMode.dark);
                              isSwitchActive = true;
                            } else {
                              widget.controller
                                  .updateThemeMode(ThemeMode.light);
                              isSwitchActive = false;
                            }
                            setState(() {});
                          })
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _buildListSettings(BuildContext context) {
    final FixedExtentScrollController _scrollController =
        FixedExtentScrollController();
    return Container(
      color: Colors.black26.withOpacity(0.05),
      width: MediaQuery.of(context).size.width * 0.25,
      child: ClickableListWheelScrollView(
        scrollController: _scrollController,
        itemHeight: 100,
        itemCount: 100,
        child: ListWheelScrollView.useDelegate(
          controller: _scrollController,
          physics: const FixedExtentScrollPhysics(),
          itemExtent: 100,
          overAndUnderCenterOpacity: 0.5,
          clipBehavior: Clip.none,
          renderChildrenOutsideViewport: true,
          childDelegate: ListWheelChildLoopingListDelegate(children: [
            _buildListTile('Empresa', Icons.store, context),
            _buildListTile('Tienda', Icons.storefront_rounded, context),
            _buildListTile('Personalizacion', Icons.edit, context),
            _buildListTile('Dispositivos', Icons.devices, context),
            _buildListTile('Ventas', Icons.sell, context),
            _buildListTile('Time-Out', Icons.timelapse, context),
            _buildListTile('Exportar', Icons.import_export, context),
          ]),
        ),
      ),
    );
  }

  Widget _buildListTile(String label, IconData icon, context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: ListTile(
        title: Text(
          label,
        ),
        trailing: Icon(
          icon,
          size: 30,
        ),
      ),
    );
  }
}
