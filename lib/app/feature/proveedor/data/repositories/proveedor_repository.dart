import 'package:jarv/app/feature/proveedor/data/model/entity_proveedor.dart';
import 'package:jarv/app/feature/proveedor/data/repositories/interfaces/proveedor_repository.dart';
import 'package:jarv/shared/data/database.dart';
import 'package:jarv/shared/data/model/entity.dart';

class ProveedorRepositoryImpl extends ProveedorRepository {
  final AppDatabase _appDatabase;
  ProveedorRepositoryImpl(this._appDatabase);

  @override
  Future<List<Proveedor>> findAllProveedores() {
    return _appDatabase.proveedorDao.findAllProveedores();
  }

  @override
  Future<void> insertProveedor(Proveedor proveedor) {
    return _appDatabase.proveedorDao.insertProveedor(proveedor);
  }

  @override
  Stream<Familia?> findFamiliaById(String id) {
    return _appDatabase.familiaDao.findFamiliaById(id);
  }

  @override
  Future<void> insertFamiliaProveedor(FamiliaProveedor familia) {
    return _appDatabase.familiaProveedorDao.insertFamiliaProveedor(familia);
  }

  @override
  Future<List<FamiliaProveedor>> findFamiliaByCif(String cif) {
    return _appDatabase.familiaProveedorDao.findFamiliaByCif(cif);
  }
}
