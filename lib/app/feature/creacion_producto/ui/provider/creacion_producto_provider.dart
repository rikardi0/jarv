import 'package:flutter/material.dart';
import 'package:jarv/app/feature/creacion_producto/data/model/entity_creacion_producto.dart';
import 'package:jarv/shared/data/model/entity.dart';

class CreacionProductoProvider extends ChangeNotifier {
  String? recetaId;
  List<IngredienteReceta> listIngredienteReceta = [];
  List<Familia> listFamilia = [];
  List<SubFamilia> listSubFamilia = [];

  List<Producto> listProducto = [];

  void updateRecetaId(String id) {
    recetaId = id;
    notifyListeners();
  }

  void clearRecetaId() {
    recetaId = 'vacio';
    notifyListeners();
  }

  void addIngredienteReceta(ingredienteReceta) {
    listIngredienteReceta.add(ingredienteReceta);
    notifyListeners();
  }

  void setListFamilia(List<Familia> list) {
    listFamilia = list;
    notifyListeners();
  }

  void setListSubFamilia(List<SubFamilia> list) {
    listSubFamilia = list;
    notifyListeners();
  }

  void setListProducto(List<Producto> list) {
    listProducto = list;
    notifyListeners();
  }

  void deleteIngredienteReceta({
    required int index,
  }) async {
    listIngredienteReceta.removeAt(index);
    notifyListeners();
  }
}
