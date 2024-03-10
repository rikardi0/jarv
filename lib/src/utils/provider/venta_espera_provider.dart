import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/producto_ordenado.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';

class VentaEsperaProvider extends ChangeNotifier {
  List<ProductoOrdenado> listaEspera;
  bool? mostrarElementoEspera;
  int? posicionListaEspera;

  VentaEsperaProvider({
    required this.listaEspera,
    required this.posicionListaEspera,
    required this.mostrarElementoEspera,
  });

  void addProductoEspera({
    required List<ProductoPreOrdenado?> producto,
    required String? idVenta,
    required double? totalVenta,
  }) async {
    listaEspera.add(ProductoOrdenado(
        identificadorVenta: idVenta,
        listaProducto: producto,
        totalVenta: totalVenta));
    notifyListeners();
  }

  void deleteProductoEspera({
    required int index,
  }) async {
    listaEspera.removeAt(index);
    notifyListeners();
  }

  void changeBool({
    required bool? productoEspera,
  }) async {
    mostrarElementoEspera = productoEspera;
    notifyListeners();
  }

  void changePosicionEspera({
    required int? nuevaPosicion,
  }) async {
    posicionListaEspera = nuevaPosicion;
    notifyListeners();
  }
}
