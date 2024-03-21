import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';

abstract class TicketDiarioRepository {
  Future<List<Map<String, Object?>>> findProductoByVentaId(List<dynamic> id);
  Future<List<Venta?>> findVentaByFecha(String fechaActual);
  Stream<List<String>> findAllClienteNombre();
}
