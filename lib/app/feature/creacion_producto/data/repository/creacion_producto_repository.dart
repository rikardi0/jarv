import 'package:jarv/app/feature/creacion_producto/data/model/entity_creacion_producto.dart';
import 'package:jarv/app/feature/creacion_producto/data/repository/interface/creacion_producto_repository.dart';
import 'package:jarv/shared/data/database.dart';

class CreacionProductoRepositoryImpl extends CreacionProductoRepository {
  final AppDatabase _appDatabase;

  CreacionProductoRepositoryImpl(this._appDatabase);

  @override
  Future<List<Ingrediente>> findAllIngredientes() {
    return _appDatabase.ingredienteDao.findAllIngredientes();
  }

  @override
  Future<List<Receta>> findAllRecetas() {
    return _appDatabase.recetaDao.findAllRecetas();
  }

  @override
  Future<void> insertIngrediente(Ingrediente ingrediente) {
    return _appDatabase.ingredienteDao.insertIngrediente(ingrediente);
  }

  @override
  Future<void> insertReceta(Receta receta) {
    return _appDatabase.recetaDao.insertReceta(receta);
  }

  @override
  Future<void> updateIngrediente(Ingrediente ingrediente) {
    return _appDatabase.ingredienteDao.updateIngrediente(ingrediente);
  }

  @override
  Future<void> updateReceta(Receta receta) {
    return _appDatabase.recetaDao.updateReceta(receta);
  }

  @override
  Future<void> deleteIngrediente(String idIngrediente) {
    return _appDatabase.ingredienteDao.deleteIngrediente(idIngrediente);
  }

  @override
  Future<void> deleteReceta(String idReceta) {
    return _appDatabase.recetaDao.deleteReceta(idReceta);
  }
}
