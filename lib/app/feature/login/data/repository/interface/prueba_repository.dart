import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';

abstract class PruebaRepository {
  Future<void> insertarProducto(Producto producto);
  Future<void> insertarFamilia(Familia familia);
  Future<void> insertarSubFamilia(SubFamilia subFamilia);
  Future<void> insertarCliente(Cliente cliente);
  Future<void> insertarTipoVenta(TipoVenta tipoVenta);
  Future<void> insertarTipoDevolucion(Devolucion tipoDevolucion);
}
