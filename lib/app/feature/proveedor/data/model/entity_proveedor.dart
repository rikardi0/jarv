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
class PedidoProveedor {
  @primaryKey
  final int idPedidoProveedor;
  final String idProducto;
  final String cif;
  final int unidades;
  final double coste;
  final String fecha;

  PedidoProveedor(
      {required this.idPedidoProveedor,
      required this.idProducto,
      required this.cif,
      required this.unidades,
      required this.coste,
      required this.fecha});
}

@entity
class ProductoProveedor {
  @primaryKey
  final int idProductoProveedor;
  final String idProducto;
  final String cif;

  ProductoProveedor(
      {required this.idProductoProveedor,
      required this.idProducto,
      required this.cif});
}
