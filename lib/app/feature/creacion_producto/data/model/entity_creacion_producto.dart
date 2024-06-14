import 'package:floor/floor.dart';

@entity
class Ingrediente {
  @primaryKey
  final String idIngrediente;
  final String nombreIngrediente;
  final String medida;
  final double precio;
  final double unidadesCompradas;

  Ingrediente({
    required this.idIngrediente,
    required this.nombreIngrediente,
    required this.medida,
    required this.precio,
    required this.unidadesCompradas,
  });
}

@entity
class Receta {
  @primaryKey
  final String idReceta;
  final String nombreReceta;
  final double coste;

  Receta({
    required this.idReceta,
    required this.nombreReceta,
    required this.coste,
  });
}

@entity
class IngredienteReceta {
  @primaryKey
  final String idIngredienteReceta;

  //fk Ingrediente
  final String idIngrediente;

  //fk Receta
  final String idReceta;
  final String medida;
  final double cantidad;

  IngredienteReceta({
    required this.medida,
    required this.idIngrediente,
    required this.idIngredienteReceta,
    required this.idReceta,
    required this.cantidad,
  });
}
