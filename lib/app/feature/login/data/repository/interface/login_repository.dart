import 'package:jarv/app/feature/login/data/model/entity_login.dart';
import 'package:jarv/shared/data/model/entity.dart';

abstract class LoginRepository {
  Future<List<Usuario>> findAllUsuarios();

  Future<List<Ingrediente?>> findAllIngredientes();

  Future<void> updateIngrediente(Ingrediente ingrediente);

  Future<void> insertIngrediente(Ingrediente ingrediente);

  Future<void> deleteIngrediente(String idIngrediente);

  Future<List<Receta>> findAllRecetas();

  Future<void> updateReceta(Receta receta);

  Future<void> insertReceta(Receta receta);

  Future<void> deleteReceta(String idReceta);
}
