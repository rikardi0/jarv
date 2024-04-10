import 'package:floor/floor.dart';

@entity
class Proveedor {
  @primaryKey
  final String cif;

  final String nombreEmpresa;

  final String numero;

  final String email;

  Proveedor(
      {required this.cif,
      required this.nombreEmpresa,
      required this.numero,
      required this.email});
}
