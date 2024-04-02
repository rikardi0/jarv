import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/pago_repository.dart';
import 'package:jarv/shared/data/database.dart';

class PagoRepositoryImpl extends PagoRepository {
  final AppDatabase _appDatabase;
  PagoRepositoryImpl(this._appDatabase);

  @override
  Stream<List<String>> findAllClienteNombre() {
    return _appDatabase.clienteDao.findAllClienteNombre();
  }

  @override
  Future<void> insertDetalleVenta(DetalleVenta detalleVenta) {
    return _appDatabase.detalleVentaDao.insertDetalleVenta(detalleVenta);
  }

  @override
  Future<void> insertVenta(Venta venta) {
    return _appDatabase.ventaDao.insertVenta(venta);
  }

  @override
  Future<String?> findTipoVentaById(int id) {
    return _appDatabase.tipoVentaDao.findTipoVentaByID(id);
  }
}
