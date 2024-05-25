import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:jarv/app/feature/settings/ui/view/dispositivos_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/exportar_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/institucion_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/personalizacion_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/time_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/ventas_settings_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {

  @override
  Widget build(BuildContext context) {
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

  Widget _buildListSettings(BuildContext context) {
    final FixedExtentScrollController scrollController =
        FixedExtentScrollController();
    return Container(
      color: Colors.black26.withOpacity(0.05),
      width: MediaQuery.of(context).size.width * 0.25,
      child: ClickableListWheelScrollView(
        scrollController: scrollController,
        itemHeight: 100,
        itemCount: 100,
        child: ListWheelScrollView.useDelegate(
          controller: scrollController,
          physics: const FixedExtentScrollPhysics(),
          itemExtent: 100,
          overAndUnderCenterOpacity: 0.5,
          clipBehavior: Clip.none,
          renderChildrenOutsideViewport: true,
          childDelegate: ListWheelChildLoopingListDelegate(children: [
            _buildListTile('Institucion', Icons.store, context,
                InstitucionSettingsView.routeName),
            _buildListTile('Personalizacion', Icons.edit, context,
                PersonalizacionSettingsView.routeName),
            _buildListTile('Dispositivos', Icons.devices, context,
                DispositivosSettingsView.routeName),
            _buildListTile(
                'Ventas', Icons.sell, context, VentasSettingsView.routeName),
            _buildListTile('Time-Out', Icons.timelapse, context,
                TimeSettingsView.routeName),
            _buildListTile('Exportar', Icons.import_export, context,
                ExportarSettingsView.routeName),
          ]),
        ),
      ),
    );
  }

  Widget _buildListTile(
      String label, IconData icon, context, String routeName) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Card(
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
      ),
    );
  }
}
