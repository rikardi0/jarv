import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';

class VentaEsperaProvider extends ChangeNotifier {
  List<double> totalVenta;
  List<String?> identficadoresVenta;
  List<ProductoPreOrdenado?> listaProducto;

  VentaEsperaProvider({
    required this.listaProducto,
    required this.totalVenta,
    required this.identficadoresVenta,
  });

  void addProducto({
    required List<ProductoPreOrdenado?> producto,
  }) async {
    listaProducto.addAll(producto);
    notifyListeners();
  }

  void clearProducto() async {
    listaProducto.clear();
    notifyListeners();
  }

  void updateTotal({
    required double nuevoTotal,
  }) async {
    totalVenta.add(nuevoTotal);
    notifyListeners();
  }

  void addIdentificadores({
    required String? nuevoIdentificador,
  }) async {
    identficadoresVenta.add(nuevoIdentificador);
    notifyListeners();
  }
}
