import 'package:get_it/get_it.dart';
import 'package:jarv/app/feature/login/data/repository/interface/login_repository.dart';
import 'package:jarv/app/feature/login/data/repository/interface/prueba_repository.dart';
import 'package:jarv/app/feature/login/data/repository/login_repository.dart';
import 'package:jarv/app/feature/login/data/repository/prueba_repository.dart';
import 'package:jarv/app/feature/proveedor/data/repositories/interfaces/proveedor_repository.dart';
import 'package:jarv/app/feature/proveedor/data/repositories/proveedor_repository.dart';
import 'package:jarv/app/feature/venta/data/repositories/cliente_repository.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/menu_repository.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/ticket_diario_repository.dart';
import 'package:jarv/app/feature/venta/data/repositories/menu_repository.dart';
import 'package:jarv/app/feature/venta/data/repositories/pago_repository.dart';
import 'package:jarv/app/feature/venta/data/repositories/ticket_diario_repository.dart';
import 'package:jarv/shared/data/database.dart';

import '../../app/feature/venta/data/repositories/interfaces/cliente_repository.dart';
import '../../app/feature/venta/data/repositories/interfaces/pago_repository.dart';

final GetIt localService = GetIt.I;

Future<void> initializeDependencies() async {
  final AppDatabase databaseJARV =
      await $FloorAppDatabase.databaseBuilder('JARV.db').build();

  localService.registerSingleton<AppDatabase>(databaseJARV);

  localService.registerFactory<MenuRepository>(
      () => MenuRepositoryImpl(localService<AppDatabase>()));

  localService.registerFactory<PagoRepository>(
      () => PagoRepositoryImpl(localService<AppDatabase>()));

  localService.registerFactory<ClienteRepository>(
      () => ClienteRepositoryImpl(localService<AppDatabase>()));

  localService.registerFactory<TicketDiarioRepository>(
      () => TicketDiarioRepositoryImpl(localService<AppDatabase>()));

  localService.registerFactory<LoginRepository>(
      () => LoginRepositoryImpl(localService<AppDatabase>()));

  localService.registerFactory<PruebaRepository>(
      () => PruebaRepositoryImpl(localService<AppDatabase>()));

  localService.registerFactory<ProveedorRepository>(
      () => ProveedorRepositoryImpl(localService<AppDatabase>()));
}
