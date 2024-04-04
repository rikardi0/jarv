import 'dart:async';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'package:floor/floor.dart';
import 'data-source/dao.dart';
import 'model/entity.dart';
import '../../app/feature/login/data/data-source/dao_login.dart';
import '../../app/feature/login/data/model/entity_login.dart';
import '../../app/feature/venta/data/data-sources/dao_venta.dart';
import '../../app/feature/venta/data/model/entity_venta.dart';

part 'database.g.dart';

@Database(version: 1, entities: [
  Familia,
  SubFamilia,
  TipoVenta,
  Devolucion,
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
  DevolucionDao get devolucionDao;
  PedidoDao get pedidoDao;
  StockDao get stockDao;
  MermaDao get mermaDao;
  TrabajadorDao get trabajadordao;
  AccesoPuestoDao get accesoPuestoDao;
  SeguridadSocialDao get seguridadSocialDao;
  DetalleVentaDao get detalleVentaDao;
  VentaDao get ventaDao;
  TipoVentaDao get tipoVentaDao;
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
