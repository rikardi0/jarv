import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';

abstract class PagoRepository {
  Future<void> insertDetalleVenta(DetalleVenta detalleVenta);
  Future<void> insertVenta(Venta venta);
  Stream<List<String>> findAllClienteNombre();
}
