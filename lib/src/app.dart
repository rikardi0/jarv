import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
                create: (_) => VentaEsperaProvider(
                      totalVenta: [],
                      identficadoresVenta: [],
                      listaProducto: [],
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

            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,

            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute<void>(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case LoginScreen.routeName:
                      return LoginScreen(
                        usuarios: database.usuarioDao,
                      );
                    case MenuScreen.routeName:
                      return MenuScreen(
                        familia: database.familiaDao,
                        producto: database.productoDao,
                        subFamilia: database.subFamiliaDao,
                      );
                    case Pago.routeName:
                      return const Pago();
                    case Espera.routeName:
                      return const Espera();
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    default:
                      return LoginScreen(
                        usuarios: database.usuarioDao,
                      );
                  }
                },
              );
            },
          ),
        );
      },
    );
  }
}
