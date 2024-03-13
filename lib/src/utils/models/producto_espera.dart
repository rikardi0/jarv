import 'package:jarv/src/utils/models/producto_ordenado.dart';

class ProductoEspera {
  ProductoEspera(
      {required this.identificadorVenta,
      required this.listaProducto,
      required this.totalVenta});

  List<ProductoOrdenado?> listaProducto;
  String? identificadorVenta;
  double? totalVenta;
}
