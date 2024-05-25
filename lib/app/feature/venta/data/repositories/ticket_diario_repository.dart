import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/ticket_diario_repository.dart';
import 'package:jarv/shared/data/database.dart';

class TicketDiarioRepositoryImpl extends TicketDiarioRepository {
  final AppDatabase _appDatabase;

  TicketDiarioRepositoryImpl(this._appDatabase);

  @override
  Stream<List<String>> findAllClienteNombre() {
    return _appDatabase.clienteDao.findAllClienteNombre();
  }

  @override
  Future<List<Map<String, Object?>>> findProductoByVentaId(List<dynamic> id) {
    return _appDatabase.database.rawQuery('''
    SELECT Producto.*, Producto.iva, DetalleVenta.cantidad
    FROM DetalleVenta
    INNER JOIN Producto ON Producto.productoId = DetalleVenta.productoId
    WHERE DetalleVenta.idVenta = ?
    ''', id);
  }

  @override
  Future<List<Venta?>> findVentaByFecha(String fechaActual) {
    return _appDatabase.ventaDao.findVentaByFecha(fechaActual);
  }

  @override
  Future<List<TipoVenta>> findAllTipoVenta() {
    return _appDatabase.tipoVentaDao.findAllTipoVenta();
  }
}
