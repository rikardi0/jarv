import 'package:floor/floor.dart';
import 'package:jarv/app/feature/proveedor/data/model/entity_proveedor.dart';

@dao
abstract class ProveedorDao {
  @Query('SELECT * FROM Proveedor')
  Future<List<Proveedor>> findAllProveedores();

  @Query('SELECT nombreEmpresa FROM Proveedor')
  Stream<List<String>> findAllProveedorNombre();

  @Query('SELECT * FROM Proveedor WHERE cif = :id')
  Stream<Proveedor?> findProveedorById(String id);

  @insert
  Future<void> insertProveedor(Proveedor proveedor);

  @update
  Future<void> updateProveedor(Proveedor proveedor);
}

@dao
abstract class PedidoProveedorDao {
  @Query('SELECT * FROM PedidosProveedor')
  Future<List<PedidoProveedor>> findAllProveedores();

  @insert
  Future<void> insertPedidoProveedor(PedidoProveedor proveedor);

  @update
  Future<void> updatePedidoProveedor(PedidoProveedor proveedor);
}

@dao
abstract class ProductoProveedorDao {
  @Query('SELECT * FROM ProductoProveedor')
  Future<List<ProductoProveedor>> findAllProveedores();

  @insert
  Future<void> insertProductoProveedor(ProductoProveedor proveedor);

  @update
  Future<void> updateProductoProveedor(ProductoProveedor proveedor);
}
