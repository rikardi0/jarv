import 'package:jarv/app/feature/login/data/model/entity_login.dart';
import 'package:jarv/app/feature/login/data/repository/interface/login_repository.dart';
import 'package:jarv/shared/data/database.dart';
import 'package:jarv/shared/data/model/entity.dart';

class LoginRepositoryImpl extends LoginRepository {
  final AppDatabase _appDatabase;

  LoginRepositoryImpl(this._appDatabase);

  @override
  Future<List<Usuario>> findAllUsuarios() {
    return _appDatabase.usuarioDao.findAllUsuarios();
  }

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
