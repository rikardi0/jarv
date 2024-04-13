import 'package:jarv/app/feature/inventario/data/repositories/interface/inventario_repository.dart';
import 'package:jarv/shared/data/database.dart';
import 'package:jarv/shared/data/model/entity.dart';

class InventarioRepositoryImpl extends InventarioRepository {
  final AppDatabase _appDatabase;

  InventarioRepositoryImpl(this._appDatabase);

  @override
  Future<List<Familia>> findAllFamilias() {
    return _appDatabase.familiaDao.findAllFamilias();
  }

  @override
  Future<void> insertFamilia(Familia familia) {
    return _appDatabase.familiaDao.insertFamilia(familia);
  }

  @override
  Future<void> updateFamilia(Familia familia) {
    return _appDatabase.familiaDao.updateFamilia(familia);
  }

  @override
  Future<List<Producto>> findAllProductos() {
    return _appDatabase.productoDao.findAllProductos();
  }

  @override
  Future<List<Producto?>> findProductoBySubFamiliaId(String id) {
    return _appDatabase.productoDao.findProductoBySubFamiliaId(id);
  }

  @override
  Future<void> updateProducto(Producto producto) {
    return _appDatabase.productoDao.updateProducto(producto);
  }

  @override
  Future<void> insertProducto(Producto producto) {
    return _appDatabase.productoDao.insertProducto(producto);
  }

  @override
  Future<List<SubFamilia>> findAllSubFamilias() {
    return _appDatabase.subFamiliaDao.findAllSubFamilias();
  }

  @override
  Future<List<SubFamilia?>> findSubFamiliaByFamilia(String id) {
    return _appDatabase.subFamiliaDao.findSubFamiliaByFamilia(id);
  }

  @override
  Future<void> insertSubFamilia(SubFamilia subfamilia) {
    return _appDatabase.subFamiliaDao.insertSubFamilia(subfamilia);
  }

  @override
  Future<void> updateSubFamilia(SubFamilia subfamilia) {
    return _appDatabase.subFamiliaDao.updateSubFamilia(subfamilia);
  }
}
