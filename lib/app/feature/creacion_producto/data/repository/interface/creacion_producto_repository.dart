import 'package:jarv/app/feature/creacion_producto/data/model/entity_creacion_producto.dart';

abstract class CreacionProductoRepository {
  Future<List<Ingrediente?>> findAllIngredientes();

  Future<void> updateIngrediente(Ingrediente ingrediente);

  Future<void> insertIngrediente(Ingrediente ingrediente);

  Future<void> deleteIngrediente(String idIngrediente);

  Future<List<Receta>> findAllRecetas();

  Future<void> updateReceta(Receta receta);

  Future<void> insertReceta(Receta receta);

  Future<void> deleteReceta(String idReceta);
}
