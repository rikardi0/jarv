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

@entity
class FamiliaProveedor {
  @primaryKey
  final String familiaId;

//foreign key PROVEEDOR
  final String cif;
  final String nombreFamilia;
  final String nombreSubFamilia;

  FamiliaProveedor(
      {required this.cif,
      required this.nombreFamilia,
      required this.nombreSubFamilia,
      required this.familiaId});
}
