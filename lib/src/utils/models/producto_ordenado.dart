import 'package:jarv/src/utils/models/producto_preordenado.dart';

class ProductoOrdenado {
  ProductoOrdenado(
      {required this.identificadorVenta,
      required this.listaProducto,
      required this.totalVenta});

  List<ProductoPreOrdenado?> listaProducto;
  String? identificadorVenta;
  double? totalVenta;
}
