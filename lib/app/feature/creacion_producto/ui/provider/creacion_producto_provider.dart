import 'package:flutter/material.dart';
import 'package:jarv/shared/data/model/entity.dart';

class PreIngredienteReceta {
  final String idIngredienteReceta;
  final String nombreIngrediente;
  final String idIngrediente;
  final String idReceta;
  final double precio;
  final String medida;
  final double cantidad;

  PreIngredienteReceta(
      {required this.idIngredienteReceta,
      required this.nombreIngrediente,
      required this.idIngrediente,
      required this.idReceta,
      required this.precio,
      required this.medida,
      required this.cantidad});
}

class CreacionProductoProvider extends ChangeNotifier {
  String? recetaId;
  List<PreIngredienteReceta> listIngredienteReceta = [];
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

  void addIngredienteReceta(PreIngredienteReceta ingredienteReceta) {
    listIngredienteReceta.add(ingredienteReceta);
    notifyListeners();
  }

  void deleteItemIngredienteReceta(PreIngredienteReceta preIngredienteReceta) {
    listIngredienteReceta.removeWhere((element) =>
        element.idIngrediente.contains(preIngredienteReceta.idIngrediente) &&
        element.idReceta.contains(preIngredienteReceta.idReceta));
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
