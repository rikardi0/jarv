import 'package:jarv/app/feature/login/data/repository/interface/prueba_repository.dart';
import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/shared/data/database.dart';

class PruebaRepositoryImpl extends PruebaRepository {
  final AppDatabase _appDatabase;
  PruebaRepositoryImpl(this._appDatabase);
  @override
  Future<void> insertarCliente(Cliente cliente) {
    return _appDatabase.clienteDao.insertCliente(cliente);
  }

  @override
  Future<void> insertarFamilia(Familia familia) {
    return _appDatabase.familiaDao.insertFamilia(familia);
  }

  @override
  Future<void> insertarProducto(Producto producto) {
    return _appDatabase.productoDao.insertProducto(producto);
  }

  @override
  Future<void> insertarSubFamilia(SubFamilia subFamilia) {
    return _appDatabase.subFamiliaDao.insertSubFamilia(subFamilia);
  }

  @override
  Future<void> insertarTipoVenta(TipoVenta tipoVenta) {
    return _appDatabase.tipoVentaDao.insertTipoVenta(tipoVenta);
  }
}
