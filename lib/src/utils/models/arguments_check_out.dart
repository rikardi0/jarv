import 'package:jarv/src/utils/models/producto_ordenado.dart';

class CheckOutArgument {
  CheckOutArgument({
    required this.productoAgregado,
    required this.totalVenta,
    required this.fechaVenta,
  });

  List<ProductoOrdenado?> productoAgregado;
  double totalVenta;
  DateTime fechaVenta;
}
