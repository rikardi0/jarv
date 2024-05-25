import '../../model/entity_venta.dart';

abstract class ClienteRepository {
  Stream<List<Cliente>> findAllClientes();

  Future<void> insertCliente(Cliente cliente);
  Future<void> updateCliente(Cliente cliente);
}
