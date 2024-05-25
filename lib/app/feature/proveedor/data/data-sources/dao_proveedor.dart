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
abstract class FamiliaProveedorDao {
  @insert
  Future<void> insertFamiliaProveedor(FamiliaProveedor familia);
}

@dao
abstract class SubFamiliaProveedorDao {
  @insert
  Future<void> insertFamiliaProveedor(SubFamiliaProveedor familia);
}
