import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';
import '../db.dart';

part 'database.g.dart';

@Database(version: 2, entities: [
  Familia,
  SubFamilia,
  Producto,
  Proveedor,
  Pedido,
  Stock,
  Merma,
  Trabajador,
  AccesoPuesto,
  SeguridadSocial,
  DetalleVenta,
  Venta,
  CosteFijo,
  Cliente,
  Tienda,
  Empresa,
  ClienteJARV,
  Impuestos,
  Usuario,
  Oferta,
  ProductoOferta
])
abstract class AppDatabase extends FloorDatabase {
  FamiliaDao get familiaDao;
  SubFamiliaDao get subFamiliaDao;
  ProductoDao get productoDao;
  ProveedorDao get proveedorDao;
  PedidoDao get pedidoDao;
  StockDao get stockDao;
  MermaDao get mermaDao;
  TrabajadorDao get trabajadordao;
  AccesoPuestoDao get accesoPuestoDao;
  SeguridadSocialDao get seguridadSocialDao;
  DetalleVentaDao get detalleVentaDao;
  VentaDao get ventaDao;
  CosteFijoDao get costeFijoDao;
  ClienteDao get clienteDao;
  TiendaDao get tiendaDao;
  EmpresaDao get empresaDao;
  ClienteJARVDao get clienteJARVDao;
  ImpuestosDao get impuestosDao;
  UsuarioDao get usuarioDao;
  OfertaDao get ofertaDao;
  ProductoOfertaDao get productoOfertaDao;
}
