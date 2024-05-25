import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:jarv/app/feature/login/ui/view/login.dart';
import 'package:jarv/app/feature/proveedor/ui/view/proveedor_view.dart';
import 'package:jarv/app/feature/venta/ui/widgets/cliente_field.dart';
import 'package:jarv/core/theme/custom_theme.dart';
import 'package:provider/provider.dart';

import '../core/settings/settings_controller.dart';
import '../core/settings/settings_view.dart';
import 'feature/venta/ui/view/view_venta.dart';
import 'feature/venta/ui/provider/venta_espera_provider.dart';

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
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case LoginScreen.routeName:
            return LoginScreen();
          case MenuScreen.routeName:
            return const MenuScreen();
          case Pago.routeName:
            return Pago();
          case Espera.routeName:
            return const Espera();
          case ClienteMenu.routeName:
            return ClienteMenu();
          case ClienteField.routeName:
            return ClienteField();
          case ConsumicionPropia.routeName:
            return ConsumicionPropia();
          case TicketDiario.routeName:
            return TicketDiario();
          case Devolucion.routeName:
            return const Devolucion();
          case ProveedorView.routeName:
            return ProveedorView();
          case CierreDiario.routeName:
            return const CierreDiario();
          case SettingsView.routeName:
            return SettingsView(controller: settingsController);
          default:
            return LoginScreen();
        }
      },
    );
  }
}
