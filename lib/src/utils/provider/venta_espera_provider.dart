import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/producto_espera.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';

class VentaEsperaProvider extends ChangeNotifier {
  List<ProductoEspera> listaEspera;

  VentaEsperaProvider({
    required this.listaEspera,
  });

  void addProductoEspera({
    required List<ProductoPreOrdenado?> producto,
    required String? idVenta,
    required double? totalVenta,
  }) async {
    listaEspera.add(ProductoEspera(
        identificadorVenta: idVenta,
        listaProducto: producto,
        totalVenta: totalVenta));
    notifyListeners();
  }
}
