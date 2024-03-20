import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/data/model/producto_espera.dart';
import 'package:jarv/app/feature/venta/data/model/producto_ordenado.dart';

class VentaEsperaProvider extends ChangeNotifier {
  List<ProductoEspera> listaEspera;
  bool? mostrarElementoEspera;
  int? posicionListaEspera;

  VentaEsperaProvider({
    required this.listaEspera,
    required this.posicionListaEspera,
    required this.mostrarElementoEspera,
  });

  void addProductoEspera({
    required List<ProductoOrdenado?> producto,
    required String? idVenta,
    required double? totalVenta,
  }) async {
    listaEspera.add(ProductoEspera(
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
