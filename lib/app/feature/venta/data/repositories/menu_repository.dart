import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/menu_repository.dart';
import '../../../../../shared/data/database.dart';

class MenuRepositoryImpl implements MenuRepository {
  MenuRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Stream<List<Familia>> findAllFamilias() {
    return _database.familiaDao.findAllFamilias().asStream();
  }

  @override
  Stream<List<SubFamilia?>> findSubFamiliaByFamilia(String idFamilia) {
    return _database.subFamiliaDao
        .findSubFamiliaByFamilia(idFamilia)
        .asStream();
  }

  @override
  Stream<List<Producto?>> findProductoById(String idSubFamilia) {
    return _database.productoDao
        .findProductoBySubFamiliaId(idSubFamilia)
        .asStream();
  }
}
