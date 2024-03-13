import 'package:jarv/src/utils/models/producto_ordenado.dart';

class CheckOutArgument {
  CheckOutArgument(
      {required this.productoAgregado,
      required this.totalVenta,
      this.fechaVenta,
      this.horaVenta});

  List<ProductoOrdenado?> productoAgregado;
  double totalVenta;
  String? horaVenta;
  String? fechaVenta;
}
