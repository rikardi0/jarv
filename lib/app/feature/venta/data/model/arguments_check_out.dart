import 'package:jarv/app/feature/venta/data/model/producto_ordenado.dart';

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
