import 'package:floor/floor.dart';
import '../model/entity_venta.dart';

@dao
abstract class ClienteDao {
  @Query('SELECT * FROM Cliente')
  Future<List<Cliente>> findAllClientes();

  @Query('SELECT nombreCliente FROM Cliente')
  Stream<List<String>> findAllClienteNombre();

  @Query('SELECT * FROM Cliente WHERE nombreCliente = :id')
  Stream<Cliente?> findClienteById(String id);

  @update
  Future<void> updateCliente(Cliente cliente);

  @insert
  Future<void> insertCliente(Cliente cliente);
}

@dao
abstract class DetalleVentaDao {
  @Query('SELECT * FROM DetalleVenta')
  Future<List<DetalleVenta>> findAllDetalleVentas();

  @Query('SELECT producto FROM DetalleVenta')
  Stream<List<String>> findAllDetalleVentaNombre();

  @Query('SELECT * FROM DetalleVenta WHERE idVenta = :id')
  Future<List<DetalleVenta?>> findDetalleVentaById(int id);

  @insert
  Future<void> insertDetalleVenta(DetalleVenta detalleVenta);
}

@dao
abstract class VentaDao {
  @Query('SELECT * FROM Venta')
  Future<List<Venta>> findAllVentas();

  @Query('SELECT nombreCliente FROM Venta')
  Stream<List<String>> findAllVentaNombre();

  @Query('SELECT * FROM Venta WHERE idVenta = :id')
  Stream<Venta?> findVentaById(int id);

  @Query('SELECT * FROM Venta WHERE fecha = :fecha')
  Future<List<Venta?>> findVentaByFecha(String fecha);

  @Query('SELECT * FROM Venta WHERE nombreCliente = :nombre')
  Stream<List<Venta?>> findVentaByNombre(String nombre);

  @insert
  Future<void> insertVenta(Venta venta);
}

@dao
abstract class TipoVentaDao {
  @Query('SELECT tipoVenta FROM TipoVenta WHERE idTipoVenta = :id')
  Future<String?> findTipoVentaByID(int id);

  @insert
  Future<void> insertTipoVenta(TipoVenta venta);
}

@dao
abstract class DevolucionDao {
  @Query('SELECT devolucion FROM Devolucion')
  Future<List<String>> findAllTipoDevolucion();

  @insert
  Future<void> insertTipoDevolucion(Devolucion venta);
}
