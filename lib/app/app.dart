import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jarv/app/feature/inventario/ui/view/inventario_view.dart';
import 'package:jarv/app/feature/login/ui/view/login.dart';
import 'package:jarv/app/feature/proveedor/ui/view/proveedor_field.dart';
import 'package:jarv/app/feature/proveedor/ui/view/proveedor_view.dart';
import 'package:jarv/app/feature/settings/ui/provider/settings_controller.dart';
import 'package:jarv/app/feature/settings/ui/view/dispositivos_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/empresa_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/exportar_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/personalizacion_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/tienda_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/time_settings_view.dart';
import 'package:jarv/app/feature/settings/ui/view/ventas_settings_view.dart';
import 'package:jarv/app/feature/venta/ui/view/cliente_field.dart';
import 'package:jarv/core/theme/custom_theme.dart';
import 'package:provider/provider.dart';

import 'feature/venta/ui/provider/venta_espera_provider.dart';
import 'feature/venta/ui/view/view_venta.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return AnimatedBuilder(
      animation: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(
                create: (BuildContext context) => VentaEsperaProvider(
                      listaEspera: [],
                      posicionListaEspera: null,
                      mostrarElementoEspera: false,
                    ))
          ],
          child: MaterialApp(
            restorationScopeId: 'app',

            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''), // English, no country code
            ],

            // Use AppLocalizations to configure the correct application title
            // depending on the user's locale.
            //
            // The appTitle is defined in .arb files found in the localization
            // directory.
            onGenerateTitle: (BuildContext context) =>
                AppLocalizations.of(context)!.appTitle,

            theme: CustomThemeData.lightTheme(context),
            darkTheme: CustomThemeData.darkTheme(context),
            themeMode: settingsController.themeMode,

            onGenerateRoute: route,
          ),
        );
      },
    );
  }

  Route<dynamic>? route(RouteSettings routeSettings) {
    final Map<String, WidgetBuilder> loginRoutes = {
      LoginScreen.routeName: (context) => LoginScreen(),
    };
    final Map<String, WidgetBuilder> ventaRoutes = {
      MenuScreen.routeName: (context) => const MenuScreen(),
      Pago.routeName: (context) => Pago(),
      Espera.routeName: (context) => const Espera(),
      InventarioView.routeName: (context) => const InventarioView(),
      ClienteMenu.routeName: (context) => ClienteMenu(),
      ClienteField.routeName: (context) => const ClienteField(),
      ConsumicionPropia.routeName: (context) => const ConsumicionPropia(),
      TicketDiario.routeName: (context) => TicketDiario(),
      Devolucion.routeName: (context) => const Devolucion(),
      CierreDiario.routeName: (context) => const CierreDiario(),
    };
    final Map<String, WidgetBuilder> proveedorRoutes = {
      ProveedorView.routeName: (context) => const ProveedorView(),
      CreateProveedor.routeName: (context) => const CreateProveedor(),
    };

    final Map<String, WidgetBuilder> settingsRoutes = {
      SettingsView.routeName: (context) =>
          SettingsView(controller: settingsController),
      EmpresaSettingsView.routeName: (context) => const EmpresaSettingsView(),
      TiendaSettingsView.routeName: (context) => const TiendaSettingsView(),
      PersonalizacionSettingsView.routeName: (context) =>
          const PersonalizacionSettingsView(),
      DispositivosSettingsView.routeName: (context) =>
          const DispositivosSettingsView(),
      VentasSettingsView.routeName: (context) => VentasSettingsView(),
      TimeSettingsView.routeName: (context) => TimeSettingsView(),
      ExportarSettingsView.routeName: (context) => ExportarSettingsView(),
    };

    final Map<String, WidgetBuilder> routeBuilders = {
      ...loginRoutes,
      ...ventaRoutes, // Spread operator to merge maps
      ...proveedorRoutes,
      ...settingsRoutes,
    };
    final routeBuilder = routeBuilders[routeSettings.name];
    if (routeBuilder != null) {
      return MaterialPageRoute<void>(
        settings: routeSettings,
        builder: routeBuilder,
      );
    }

    return null;
  }
}
