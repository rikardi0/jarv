import 'package:floor/floor.dart';
import 'package:jarv/app/feature/creacion_producto/data/model/entity_creacion_producto.dart';

@dao
abstract class IngredienteDao {
  @Query('SELECT * FROM Ingrediente')
  Future<List<Ingrediente>> findAllIngredientes();

  @Query('SELECT nombreIngrediente FROM Ingrediente')
  Stream<List<String>> findAllNombreIngrediente();

  @Query('SELECT * FROM Ingrediente WHERE idIngrediente = :id')
  Stream<Ingrediente?> findIngredientById(int id);

  @insert
  Future<void> insertIngrediente(Ingrediente ingrediente);

  @update
  Future<void> updateIngrediente(Ingrediente ingrediente);

  @Query('DELETE FROM Ingrediente WHERE idIngrediente = :id')
  Future<void> deleteIngrediente(String id);
}

@dao
abstract class RecetasDao {
  @Query('SELECT * FROM Receta')
  Future<List<Receta>> findAllRecetas();

  @Query('SELECT * FROM Receta WHERE idReceta = :id')
  Stream<Ingrediente?> findRecetaById(int id);

  @insert
  Future<void> insertReceta(Receta receta);

  @update
  Future<void> updateReceta(Receta receta);

  @Query('DELETE FROM Receta WHERE idReceta = :id')
  Future<void> deleteReceta(String id);
}

@dao
abstract class IngredienteRecetaDao {
  @Query('SELECT * FROM IngredienteReceta')
  Future<List<IngredienteReceta>> findAllRecetas();

  @insert
  Future<void> insertRelacionReceta(IngredienteReceta receta);

  @update
  Future<void> updateRelacionReceta(IngredienteReceta receta);

  @Query('DELETE FROM IngredienteReceta WHERE idReceta = :id')
  Future<void> deleteRelacionReceta(String id);
}
