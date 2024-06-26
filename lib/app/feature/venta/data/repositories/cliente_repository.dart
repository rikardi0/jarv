import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/cliente_repository.dart';
import 'package:jarv/shared/data/database.dart';

class ClienteRepositoryImpl extends ClienteRepository {
  final AppDatabase _appDatabase;
  ClienteRepositoryImpl(this._appDatabase);

  @override
  Stream<List<Cliente>> findAllClientes() {
    return _appDatabase.clienteDao.findAllClientes().asStream();
  }

  @override
  Future<void> insertCliente(Cliente cliente) {
    return _appDatabase.clienteDao.insertCliente(cliente);
  }

  @override
  Future<void> updateCliente(Cliente cliente) {
    return _appDatabase.clienteDao.updateCliente(cliente);
  }
}
