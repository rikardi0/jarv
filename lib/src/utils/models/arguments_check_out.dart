import 'package:jarv/src/utils/models/producto_preordenado.dart';

class CheckOutArgument {
  CheckOutArgument(
      {required this.productoAgregado,
      required this.totalVenta,
      this.fechaVenta,
      this.horaVenta});

  List<ProductoPreOrdenado?> productoAgregado;
  double totalVenta;
  String? horaVenta;
  String? fechaVenta;
}
