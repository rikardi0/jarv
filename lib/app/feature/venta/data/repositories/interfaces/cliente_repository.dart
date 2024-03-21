import '../../model/entity_venta.dart';

abstract class ClienteRepository {
  Stream<List<Cliente>> findAllClientes();
}
