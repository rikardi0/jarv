import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jarv/config/theme/custom_theme.dart';
import 'package:provider/provider.dart';

import '../config/settings/settings_controller.dart';
import '../config/settings/settings_view.dart';
import 'data_source/db.dart';

import 'pages/pages.dart';
import 'utils/provider/venta_espera_provider.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
    required this.database,
  });
  final AppDatabase database;
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
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case LoginScreen.routeName:
            return LoginScreen(
              usuarios: database.usuarioDao,
              familia: database.familiaDao,
              subFamilia: database.subFamiliaDao,
              producto: database.productoDao,
              cliente: database.clienteDao,
            );
          case MenuScreen.routeName:
            return MenuScreen(
              familia: database.familiaDao,
              producto: database.productoDao,
              subFamilia: database.subFamiliaDao,
            );
          case Pago.routeName:
            return Pago(
              venta: database.ventaDao,
              cliente: database.clienteDao,
              detalleVenta: database.detalleVentaDao,
            );
          case Espera.routeName:
            return const Espera();
          case ClienteMenu.routeName:
            return ClienteMenu(
              cliente: database.clienteDao,
            );
          case ConsumicionPropia.routeName:
            return ConsumicionPropia(
              familia: database.familiaDao,
              subFamilia: database.subFamiliaDao,
              producto: database.productoDao,
            );
          case TicketDiario.routeName:
            return TicketDiario(
              cliente: database.clienteDao,
              ventas: database.ventaDao,
              ventaDetalle: database.detalleVentaDao,
              producto: database.productoDao,
              databaseExecutor: database.database,
            );
          case Devolucion.routeName:
            return const Devolucion();
          case CierreDiario.routeName:
            return const CierreDiario();
          case SettingsView.routeName:
            return SettingsView(controller: settingsController);
          default:
            return LoginScreen(
              usuarios: database.usuarioDao,
              familia: database.familiaDao,
              subFamilia: database.subFamiliaDao,
              producto: database.productoDao,
              cliente: database.clienteDao,
            );
        }
      },
    );
  }
}
