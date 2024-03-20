import 'package:jarv/app/feature/venta/data/model/producto_ordenado.dart';

class ProductoEspera {
  ProductoEspera(
      {required this.identificadorVenta,
      required this.listaProducto,
      required this.totalVenta});

  List<ProductoOrdenado?> listaProducto;
  String? identificadorVenta;
  double? totalVenta;
}
