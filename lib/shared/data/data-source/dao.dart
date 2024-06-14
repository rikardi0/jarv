import 'package:floor/floor.dart';

import '../model/entity.dart';

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
abstract class FamiliaDao {
  @Query('SELECT * FROM Familia')
  Future<List<Familia>> findAllFamilias();

  @Query('SELECT nombreFamilia FROM Familia')
  Stream<List<String>> findAllFamiliaNombre();

  @Query('SELECT * FROM Familia WHERE idFamilia = :id')
  Stream<Familia?> findFamiliaById(String id);

  @insert
  Future<void> insertFamilia(Familia familia);

  @update
  Future<void> updateFamilia(Familia familia);
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

  @update
  Future<void> updateSubFamilia(SubFamilia subfamilia);
}

@dao
abstract class ProductoDao {
  @Query('SELECT * FROM Producto')
  Future<List<Producto>> findAllProductos();

  @Query('SELECT producto FROM Producto')
  Stream<List<String>> findAllProductoNombre();

  @Query('SELECT * FROM Producto WHERE productoId = :id')
  Stream<Producto?> findProductoById(int id);

  @Query('SELECT * FROM Producto WHERE idSubfamilia = :id')
  Future<List<Producto?>> findProductoBySubFamiliaId(String id);

  @insert
  Future<void> insertProducto(Producto producto);

  @update
  Future<void> updateProducto(Producto producto);
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

