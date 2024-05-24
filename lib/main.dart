import 'package:flutter/material.dart';
import 'package:jarv/app/feature/settings/ui/provider/settings_controller.dart';
import 'package:jarv/app/feature/settings/ui/provider/settings_service.dart';
import 'package:jarv/core/di/locator.dart';

import 'app/app.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();

  final settingsController = SettingsController(SettingsService());

  await settingsController.loadSettings();

  runApp(MyApp(
    settingsController: settingsController,
  ));
}
