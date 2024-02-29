import 'package:jarv/src/utils/models/producto_preordenado.dart';

class VentaEsperaArgument {
  VentaEsperaArgument(this.productoEspera, this.identificador);

  List<ProductoPreOrdenado?> productoEspera;
  List<String?> identificador;
}
