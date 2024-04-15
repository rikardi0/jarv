import 'package:floor/floor.dart';

@entity
class Proveedor {
  @primaryKey
  final String cif;

  final String nombreEmpresa;

  final String numero;

  final String email;
//foreign key FAMILIA PROVEEDOR
  final String idFamilia;

//foreign key SUB-FAMILIA PROVEEDOR
  final String idSubFamilia;

  Proveedor(
      {required this.cif,
      required this.nombreEmpresa,
      required this.idFamilia,
      required this.idSubFamilia,
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

  FamiliaProveedor(
      {required this.cif,
      required this.nombreFamilia,
      required this.familiaId});
}

@entity
class SubFamiliaProveedor {
  @primaryKey
  final String subFamiliaId;

  final String nombreSubFamilia;

//foreign key PROVEEDOR
  final String cif;

  SubFamiliaProveedor(
      {required this.cif,
      required this.nombreSubFamilia,
      required this.subFamiliaId});
}
