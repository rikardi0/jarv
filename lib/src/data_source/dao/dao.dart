import 'package:floor/floor.dart';
import '../db.dart';

@dao
abstract class FamiliaDao {
  @Query('SELECT * FROM Familia')
  Future<List<Familia>> findAllFamilias();

  @Query('SELECT nombreFamilia FROM Familia')
  Stream<List<String>> findAllFamiliaNombre();

  @Query('SELECT * FROM Familia WHERE idFamilia = :id')
  Stream<Familia?> findFamiliaById(String id);

  @insert
  Future<void> insertFamilia(Familia familia);
}

@dao
abstract class SubFamiliaDao {
  @Query('SELECT * FROM SubFamilia')
  Future<List<SubFamilia>> findAllSubFamilias();

  @Query('SELECT nombreSub FROM SubFamilia')
  Stream<List<String>> findAllSubFamiliaNombre();

  @Query('SELECT * FROM SubFamilia WHERE idSubfamilia = :id')
  Stream<SubFamilia?> findSubFamiliaById(String id);

  @Query('SELECT * FROM SubFamilia WHERE idFamilia = :id')
  Future<List<SubFamilia?>> findSubFamiliaByFamilia(String id);

  @insert
  Future<void> insertSubFamilia(SubFamilia subfamilia);
}

@dao
abstract class ProductoDao {
  @Query('SELECT * FROM Producto')
  Future<List<Producto>> findAllProductos();

  @Query('SELECT producto FROM Producto')
  Stream<List<String>> findAllProductoNombre();

  @Query('SELECT * FROM Producto WHERE productoId = :id')
  Stream<Producto?> findProductoById(String id);

  @Query('SELECT * FROM Producto WHERE idSubfamilia = :id')
  Future<List<Producto?>> findProductoBySubFamiliaId(String id);

  @insert
  Future<void> insertProducto(Producto producto);
}

@dao
abstract class ProveedorDao {
  @Query('SELECT * FROM Proveedor')
  Future<List<Proveedor>> findAllProveedors();

  @Query('SELECT nombreEmpresa FROM Proveedor')
  Stream<List<String>> findAllProveedorNombre();

  @Query('SELECT * FROM Proveedor WHERE cif = :id')
  Stream<Proveedor?> findProveedorById(String id);

  @insert
  Future<void> insertProveedor(Proveedor proveedor);
}

@dao
abstract class PedidoDao {
  @Query('SELECT * FROM Pedido')
  Future<List<Pedido>> findAllPedidos();

  @Query('SELECT producto FROM Pedido')
  Stream<List<String>> findAllPedidoNombre();

  @Query('SELECT * FROM Pedido WHERE cifProveedor = :id')
  Stream<Pedido?> findPedidoById(String id);

  @insert
  Future<void> insertPedido(Pedido pedido);
}

@dao
abstract class StockDao {
  @Query('SELECT * FROM Stock')
  Future<List<Stock>> findAllStocks();

  @Query('SELECT producto FROM Stock')
  Stream<List<String>> findAllStockNombre();

  @Query('SELECT * FROM Stock WHERE productoId = :id')
  Stream<Stock?> findStockById(int id);

  @insert
  Future<void> insertStock(Stock stock);
}

@dao
abstract class MermaDao {
  @Query('SELECT * FROM Merma')
  Future<List<Merma>> findAllMermas();

  @Query('SELECT producto FROM Merma')
  Stream<List<String>> findAllMermaNombre();

  @Query('SELECT * FROM Merma WHERE productoId = :id')
  Stream<Merma?> findMermaById(int id);

  @insert
  Future<void> insertMerma(Merma merma);
}

@dao
abstract class TrabajadorDao {
  @Query('SELECT * FROM Trabajador')
  Future<List<Trabajador>> findAllTrabajadors();

  @Query('SELECT nombre FROM Trabajador')
  Stream<List<String>> findAllTrabajadorNombre();

  @Query('SELECT * FROM Trabajador WHERE dni = :id')
  Stream<Trabajador?> findTrabajadorById(String id);

  @insert
  Future<void> insertTrabajador(Trabajador trabajador);
}

@dao
abstract class AccesoPuestoDao {
  @Query('SELECT * FROM AccesoPuesto')
  Future<List<AccesoPuesto>> findAllAccesoPuestos();

  @Query('SELECT puesto FROM AccesoPuesto')
  Stream<List<String>> findAllAccesoPuestoNombre();

  @Query('SELECT * FROM AccesoPuesto WHERE trabajadorDni = :id')
  Stream<AccesoPuesto?> findAccesoPuestoById(String id);

  @insert
  Future<void> insertAccesoPuesto(AccesoPuesto accesoPuesto);
}

@dao
abstract class SeguridadSocialDao {
  @Query('SELECT * FROM SeguridadSocial')
  Future<List<SeguridadSocial>> findAllSeguridadSocials();

  @Query('SELECT puesto FROM SeguridadSocial')
  Stream<List<String>> findAllSeguridadSocialNombre();

  @Query('SELECT * FROM SeguridadSocial WHERE puesto = :id')
  Stream<SeguridadSocial?> findSeguridadSocialById(String id);

  @insert
  Future<void> insertSeguridadSocial(SeguridadSocial seguridadSocial);
}

@dao
abstract class DetalleVentaDao {
  @Query('SELECT * FROM DetalleVenta')
  Future<List<DetalleVenta>> findAllDetalleVentas();

  @Query('SELECT producto FROM DetalleVenta')
  Stream<List<String>> findAllDetalleVentaNombre();

  @Query('SELECT * FROM DetalleVenta WHERE idVenta = :id')
  Stream<DetalleVenta?> findDetalleVentaById(int id);

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

  @Query(
      'SELECT * FROM Venta WHERE idVenta BETWEEN :firstDate AND :secondDate ORDER BY idVenta ASC')
  Stream<List<Venta?>> findVentaByRange(int firstDate, int secondDate);

  @Query('SELECT * FROM Venta WHERE fecha = :fecha')
  Future<List<Venta?>> findVentaByFecha(String fecha);

  @Query('SELECT * FROM Venta WHERE nombreCliente = :nombre')
  Stream<List<Venta?>> findVentaByNombre(String nombre);

  @insert
  Future<void> insertVenta(Venta venta);
}

@dao
abstract class CosteFijoDao {
  @Query('SELECT * FROM CosteFijo')
  Future<List<CosteFijo>> findAllCosteFijos();

  @Query('SELECT nombre FROM CosteFijo')
  Stream<List<String>> findAllCosteFijoNombre();

  @Query('SELECT * FROM CosteFijo WHERE nombre = :id')
  Stream<CosteFijo?> findCosteFijoById(String id);

  @insert
  Future<void> insertCosteFijo(CosteFijo costeFijo);
}

@dao
abstract class ClienteDao {
  @Query('SELECT * FROM Cliente')
  Future<List<Cliente>> findAllClientes();

  @Query('SELECT nombreCliente FROM Cliente')
  Stream<List<String>> findAllClienteNombre();

  @Query('SELECT * FROM Cliente WHERE nombreCliente = :id')
  Stream<Cliente?> findClienteById(String id);

  @insert
  Future<void> insertCliente(Cliente cliente);
}

@dao
abstract class TiendaDao {
  @Query('SELECT * FROM Tienda')
  Future<List<Tienda>> findAllTiendas();

  @Query('SELECT nombreTienda FROM Tienda')
  Stream<List<String>> findAllTiendaNombre();

  @Query('SELECT * FROM Tienda WHERE nombreTienda = :id')
  Stream<Tienda?> findTiendaById(String id);

  @insert
  Future<void> insertTienda(Tienda tienda);
}

@dao
abstract class EmpresaDao {
  @Query('SELECT * FROM Empresa')
  Future<List<Empresa>> findAllEmpresas();

  @Query('SELECT nombreFiscal FROM Empresa')
  Stream<List<String>> findAllEmpresaNombre();

  @Query('SELECT * FROM Empresa WHERE nombreFiscal = :id')
  Stream<Empresa?> findEmpresaById(String id);

  @insert
  Future<void> insertEmpresa(Empresa empresa);
}

@dao
abstract class ClienteJARVDao {
  @Query('SELECT * FROM ClienteJARV')
  Future<List<ClienteJARV>> findAllClienteJARVs();

  @Query('SELECT email FROM ClienteJARV')
  Stream<List<String>> findAllClienteJARVEmail();

  @Query('SELECT * FROM ClienteJARV WHERE idCliente = :id')
  Stream<ClienteJARV?> findClienteJARVById(int id);

  @insert
  Future<void> insertClienteJARV(ClienteJARV clienteJARV);
}

@dao
abstract class ImpuestosDao {
  @Query('SELECT * FROM Impuestos')
  Future<List<Impuestos>> findAllImpuestoss();

  @Query('SELECT impuesto FROM Impuestos')
  Stream<List<String>> findAllImpuestosNombre();

  @Query('SELECT * FROM Impuestos WHERE impuesto = :id')
  Stream<Impuestos?> findImpuestosById(String id);

  @insert
  Future<void> insertImpuestos(Impuestos impuestos);
}

@dao
abstract class UsuarioDao {
  @Query('SELECT * FROM Usuario')
  Future<List<Usuario>> findAllUsuarios();

  @Query('SELECT nombre, idUsuario FROM Usuario')
  Stream<List<String>> findAllUsuarioNombre();

  @Query('SELECT * FROM Usuario WHERE idUsuario = :id')
  Stream<Usuario?> findUsuarioById(int id);

  @Query('SELECT contrasena FROM Usuario WHERE nombre = :nombre')
  Stream<Usuario?> findPasswordByUser(String nombre);

  @insert
  Future<void> insertUsuario(Usuario usuario);
}

@dao
abstract class OfertaDao {
  @Query('SELECT * FROM Oferta')
  Future<List<Oferta>> findAllOfertas();

  @Query('SELECT nombre, idOferta FROM Oferta')
  Stream<List<String>> findAllOfertaNombre();

  @Query('SELECT * FROM Oferta WHERE idOferta = :id')
  Stream<Oferta?> findOfertaById(int id);

  @insert
  Future<void> insertOferta(Oferta oferta);
}

@dao
abstract class ProductoOfertaDao {
  @Query('SELECT * FROM ProductoOferta')
  Future<List<ProductoOferta>> findAllProductoOfertas();

  @Query('SELECT idOferta, idProducto FROM ProductoOferta')
  Stream<List<String>> findAllProductoOfertaId();

  @Query('SELECT * FROM ProductoOferta WHERE idOferta = :id')
  Stream<ProductoOferta?> findProductoOfertaById(int id);

  @insert
  Future<void> insertProductoOferta(ProductoOferta productoOferta);
}
