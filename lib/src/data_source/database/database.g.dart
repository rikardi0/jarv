// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FamiliaDao? _familiaDaoInstance;

  SubFamiliaDao? _subFamiliaDaoInstance;

  ProductoDao? _productoDaoInstance;

  ProveedorDao? _proveedorDaoInstance;

  PedidoDao? _pedidoDaoInstance;

  StockDao? _stockDaoInstance;

  MermaDao? _mermaDaoInstance;

  TrabajadorDao? _trabajadordaoInstance;

  AccesoPuestoDao? _accesoPuestoDaoInstance;

  SeguridadSocialDao? _seguridadSocialDaoInstance;

  DetalleVentaDao? _detalleVentaDaoInstance;

  VentaDao? _ventaDaoInstance;

  CosteFijoDao? _costeFijoDaoInstance;

  ClienteDao? _clienteDaoInstance;

  TiendaDao? _tiendaDaoInstance;

  EmpresaDao? _empresaDaoInstance;

  ClienteJARVDao? _clienteJARVDaoInstance;

  ImpuestosDao? _impuestosDaoInstance;

  UsuarioDao? _usuarioDaoInstance;

  OfertaDao? _ofertaDaoInstance;

  ProductoOfertaDao? _productoOfertaDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Familia` (`idFamilia` TEXT NOT NULL, `nombreFamilia` TEXT NOT NULL, `idUsuario` TEXT NOT NULL, PRIMARY KEY (`idFamilia`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SubFamilia` (`idSubfamilia` TEXT NOT NULL, `nombreSub` TEXT NOT NULL, `idFamilia` TEXT NOT NULL, PRIMARY KEY (`idSubfamilia`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Producto` (`productoId` INTEGER NOT NULL, `producto` TEXT NOT NULL, `precio` REAL NOT NULL, `medida` INTEGER NOT NULL, `coste` REAL NOT NULL, `iva` REAL NOT NULL, `idSubfamilia` TEXT NOT NULL, PRIMARY KEY (`productoId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Proveedor` (`cif` TEXT NOT NULL, `nombreEmpresa` TEXT NOT NULL, `numero` INTEGER NOT NULL, `email` TEXT NOT NULL, PRIMARY KEY (`cif`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Pedido` (`cifProveedor` TEXT NOT NULL, `producto` TEXT NOT NULL, `unidades` INTEGER NOT NULL, `costeFinal` REAL NOT NULL, `fecha` TEXT NOT NULL, PRIMARY KEY (`cifProveedor`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Stock` (`productoId` INTEGER NOT NULL, `producto` TEXT NOT NULL, `unidades` INTEGER NOT NULL, `uniConsumidas` INTEGER NOT NULL, PRIMARY KEY (`productoId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Merma` (`productoId` INTEGER NOT NULL, `producto` TEXT NOT NULL, `unidades` INTEGER NOT NULL, `fecha` TEXT NOT NULL, PRIMARY KEY (`productoId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Trabajador` (`dni` TEXT NOT NULL, `nombre` TEXT NOT NULL, `numeroTlf` TEXT NOT NULL, `horas` INTEGER NOT NULL, `precioHora` REAL NOT NULL, `puesto` TEXT NOT NULL, PRIMARY KEY (`dni`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AccesoPuesto` (`trabajadorDni` TEXT NOT NULL, `puesto` TEXT NOT NULL, `accesibilidad` TEXT NOT NULL, PRIMARY KEY (`trabajadorDni`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SeguridadSocial` (`puesto` TEXT NOT NULL, `paog` INTEGER NOT NULL, PRIMARY KEY (`puesto`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DetalleVenta` (`idVenta` INTEGER NOT NULL, `idProducto` INTEGER NOT NULL, `cantidad` INTEGER NOT NULL, `precioUnitario` REAL NOT NULL, `descuento` REAL NOT NULL, `entregado` INTEGER NOT NULL, PRIMARY KEY (`idProducto`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Venta` (`idVenta` INTEGER NOT NULL, `costeTotal` REAL NOT NULL, `ingresoTotal` REAL NOT NULL, `idUsuario` INTEGER NOT NULL, `nombreCliente` TEXT NOT NULL, `fecha` TEXT NOT NULL, PRIMARY KEY (`idVenta`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CosteFijo` (`nombre` TEXT NOT NULL, `coste` REAL NOT NULL, PRIMARY KEY (`nombre`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Cliente` (`nombreCliente` TEXT NOT NULL, `telefono` TEXT NOT NULL, `email` TEXT NOT NULL, `puntos` INTEGER NOT NULL, `nombreTienda` TEXT NOT NULL, PRIMARY KEY (`nombreCliente`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Tienda` (`nombreTienda` TEXT NOT NULL, `nombreFiscal` TEXT NOT NULL, `ciudad` TEXT NOT NULL, `codigoPostal` TEXT NOT NULL, `direccion` TEXT NOT NULL, `telefono` TEXT NOT NULL, `email` TEXT NOT NULL, `logo` TEXT NOT NULL, PRIMARY KEY (`nombreTienda`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Empresa` (`nombreFiscal` TEXT NOT NULL, `nif` INTEGER NOT NULL, `ciudad` TEXT NOT NULL, `direccion` TEXT NOT NULL, `codigoPostal` TEXT NOT NULL, `telefono` TEXT NOT NULL, `email` TEXT NOT NULL, `pais` TEXT NOT NULL, `idCliente` INTEGER NOT NULL, `nombreTienda` TEXT NOT NULL, PRIMARY KEY (`nombreFiscal`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ClienteJARV` (`idCliente` INTEGER NOT NULL, `email` TEXT NOT NULL, `contrasena` TEXT NOT NULL, `tipoSuscripcion` TEXT NOT NULL, PRIMARY KEY (`idCliente`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Impuestos` (`impuesto` TEXT NOT NULL, `cantidad` REAL NOT NULL, PRIMARY KEY (`impuesto`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Usuario` (`nombre` TEXT NOT NULL, `idUsuario` INTEGER NOT NULL, `contrasena` TEXT NOT NULL, `nombreTienda` TEXT NOT NULL, PRIMARY KEY (`nombre`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Oferta` (`idOferta` INTEGER NOT NULL, `nombre` TEXT NOT NULL, `precio` REAL NOT NULL, `coste` REAL NOT NULL, PRIMARY KEY (`idOferta`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProductoOferta` (`idOferta` INTEGER NOT NULL, `idProducto` INTEGER NOT NULL, `cantidad` INTEGER NOT NULL, `unidades` INTEGER NOT NULL, PRIMARY KEY (`idOferta`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FamiliaDao get familiaDao {
    return _familiaDaoInstance ??= _$FamiliaDao(database, changeListener);
  }

  @override
  SubFamiliaDao get subFamiliaDao {
    return _subFamiliaDaoInstance ??= _$SubFamiliaDao(database, changeListener);
  }

  @override
  ProductoDao get productoDao {
    return _productoDaoInstance ??= _$ProductoDao(database, changeListener);
  }

  @override
  ProveedorDao get proveedorDao {
    return _proveedorDaoInstance ??= _$ProveedorDao(database, changeListener);
  }

  @override
  PedidoDao get pedidoDao {
    return _pedidoDaoInstance ??= _$PedidoDao(database, changeListener);
  }

  @override
  StockDao get stockDao {
    return _stockDaoInstance ??= _$StockDao(database, changeListener);
  }

  @override
  MermaDao get mermaDao {
    return _mermaDaoInstance ??= _$MermaDao(database, changeListener);
  }

  @override
  TrabajadorDao get trabajadordao {
    return _trabajadordaoInstance ??= _$TrabajadorDao(database, changeListener);
  }

  @override
  AccesoPuestoDao get accesoPuestoDao {
    return _accesoPuestoDaoInstance ??=
        _$AccesoPuestoDao(database, changeListener);
  }

  @override
  SeguridadSocialDao get seguridadSocialDao {
    return _seguridadSocialDaoInstance ??=
        _$SeguridadSocialDao(database, changeListener);
  }

  @override
  DetalleVentaDao get detalleVentaDao {
    return _detalleVentaDaoInstance ??=
        _$DetalleVentaDao(database, changeListener);
  }

  @override
  VentaDao get ventaDao {
    return _ventaDaoInstance ??= _$VentaDao(database, changeListener);
  }

  @override
  CosteFijoDao get costeFijoDao {
    return _costeFijoDaoInstance ??= _$CosteFijoDao(database, changeListener);
  }

  @override
  ClienteDao get clienteDao {
    return _clienteDaoInstance ??= _$ClienteDao(database, changeListener);
  }

  @override
  TiendaDao get tiendaDao {
    return _tiendaDaoInstance ??= _$TiendaDao(database, changeListener);
  }

  @override
  EmpresaDao get empresaDao {
    return _empresaDaoInstance ??= _$EmpresaDao(database, changeListener);
  }

  @override
  ClienteJARVDao get clienteJARVDao {
    return _clienteJARVDaoInstance ??=
        _$ClienteJARVDao(database, changeListener);
  }

  @override
  ImpuestosDao get impuestosDao {
    return _impuestosDaoInstance ??= _$ImpuestosDao(database, changeListener);
  }

  @override
  UsuarioDao get usuarioDao {
    return _usuarioDaoInstance ??= _$UsuarioDao(database, changeListener);
  }

  @override
  OfertaDao get ofertaDao {
    return _ofertaDaoInstance ??= _$OfertaDao(database, changeListener);
  }

  @override
  ProductoOfertaDao get productoOfertaDao {
    return _productoOfertaDaoInstance ??=
        _$ProductoOfertaDao(database, changeListener);
  }
}

class _$FamiliaDao extends FamiliaDao {
  _$FamiliaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _familiaInsertionAdapter = InsertionAdapter(
            database,
            'Familia',
            (Familia item) => <String, Object?>{
                  'idFamilia': item.idFamilia,
                  'nombreFamilia': item.nombreFamilia,
                  'idUsuario': item.idUsuario
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Familia> _familiaInsertionAdapter;

  @override
  Future<List<Familia>> findAllFamilias() async {
    return _queryAdapter.queryList('SELECT * FROM Familia',
        mapper: (Map<String, Object?> row) => Familia(
            row['idFamilia'] as String,
            row['nombreFamilia'] as String,
            row['idUsuario'] as String));
  }

  @override
  Stream<List<String>> findAllFamiliaNombre() {
    return _queryAdapter.queryListStream('SELECT nombreFamilia FROM Familia',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Familia',
        isView: false);
  }

  @override
  Stream<Familia?> findFamiliaById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Familia WHERE idFamilia = ?1',
        mapper: (Map<String, Object?> row) => Familia(
            row['idFamilia'] as String,
            row['nombreFamilia'] as String,
            row['idUsuario'] as String),
        arguments: [id],
        queryableName: 'Familia',
        isView: false);
  }

  @override
  Future<void> insertFamilia(Familia familia) async {
    await _familiaInsertionAdapter.insert(familia, OnConflictStrategy.abort);
  }
}

class _$SubFamiliaDao extends SubFamiliaDao {
  _$SubFamiliaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _subFamiliaInsertionAdapter = InsertionAdapter(
            database,
            'SubFamilia',
            (SubFamilia item) => <String, Object?>{
                  'idSubfamilia': item.idSubfamilia,
                  'nombreSub': item.nombreSub,
                  'idFamilia': item.idFamilia
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SubFamilia> _subFamiliaInsertionAdapter;

  @override
  Future<List<SubFamilia>> findAllSubFamilias() async {
    return _queryAdapter.queryList('SELECT * FROM SubFamilia',
        mapper: (Map<String, Object?> row) => SubFamilia(
            row['idSubfamilia'] as String,
            row['nombreSub'] as String,
            row['idFamilia'] as String));
  }

  @override
  Stream<List<String>> findAllSubFamiliaNombre() {
    return _queryAdapter.queryListStream('SELECT nombreSub FROM SubFamilia',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'SubFamilia',
        isView: false);
  }

  @override
  Stream<SubFamilia?> findSubFamiliaById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM SubFamilia WHERE idSubfamilia = ?1',
        mapper: (Map<String, Object?> row) => SubFamilia(
            row['idSubfamilia'] as String,
            row['nombreSub'] as String,
            row['idFamilia'] as String),
        arguments: [id],
        queryableName: 'SubFamilia',
        isView: false);
  }

  @override
  Future<List<SubFamilia?>> findSubFamiliaByFamilia(String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM SubFamilia WHERE idFamilia = ?1',
        mapper: (Map<String, Object?> row) => SubFamilia(
            row['idSubfamilia'] as String,
            row['nombreSub'] as String,
            row['idFamilia'] as String),
        arguments: [id]);
  }

  @override
  Future<void> insertSubFamilia(SubFamilia subfamilia) async {
    await _subFamiliaInsertionAdapter.insert(
        subfamilia, OnConflictStrategy.abort);
  }
}

class _$ProductoDao extends ProductoDao {
  _$ProductoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _productoInsertionAdapter = InsertionAdapter(
            database,
            'Producto',
            (Producto item) => <String, Object?>{
                  'productoId': item.productoId,
                  'producto': item.producto,
                  'precio': item.precio,
                  'medida': item.medida,
                  'coste': item.coste,
                  'iva': item.iva,
                  'idSubfamilia': item.idSubfamilia
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Producto> _productoInsertionAdapter;

  @override
  Future<List<Producto>> findAllProductos() async {
    return _queryAdapter.queryList('SELECT * FROM Producto',
        mapper: (Map<String, Object?> row) => Producto(
            row['productoId'] as int,
            row['producto'] as String,
            row['precio'] as double,
            row['coste'] as double,
            row['iva'] as double,
            row['idSubfamilia'] as String,
            row['medida'] as int));
  }

  @override
  Stream<List<String>> findAllProductoNombre() {
    return _queryAdapter.queryListStream('SELECT producto FROM Producto',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Producto',
        isView: false);
  }

  @override
  Stream<Producto?> findProductoById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Producto WHERE productoId = ?1',
        mapper: (Map<String, Object?> row) => Producto(
            row['productoId'] as int,
            row['producto'] as String,
            row['precio'] as double,
            row['coste'] as double,
            row['iva'] as double,
            row['idSubfamilia'] as String,
            row['medida'] as int),
        arguments: [id],
        queryableName: 'Producto',
        isView: false);
  }

  @override
  Future<List<Producto?>> findProductoBySubFamiliaId(String id) async {
    return _queryAdapter.queryList(
        'SELECT * FROM Producto WHERE idSubfamilia = ?1',
        mapper: (Map<String, Object?> row) => Producto(
            row['productoId'] as int,
            row['producto'] as String,
            row['precio'] as double,
            row['coste'] as double,
            row['iva'] as double,
            row['idSubfamilia'] as String,
            row['medida'] as int),
        arguments: [id]);
  }

  @override
  Future<void> insertProducto(Producto producto) async {
    await _productoInsertionAdapter.insert(producto, OnConflictStrategy.abort);
  }
}

class _$ProveedorDao extends ProveedorDao {
  _$ProveedorDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _proveedorInsertionAdapter = InsertionAdapter(
            database,
            'Proveedor',
            (Proveedor item) => <String, Object?>{
                  'cif': item.cif,
                  'nombreEmpresa': item.nombreEmpresa,
                  'numero': item.numero,
                  'email': item.email
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Proveedor> _proveedorInsertionAdapter;

  @override
  Future<List<Proveedor>> findAllProveedors() async {
    return _queryAdapter.queryList('SELECT * FROM Proveedor',
        mapper: (Map<String, Object?> row) => Proveedor(
            row['cif'] as String,
            row['nombreEmpresa'] as String,
            row['numero'] as int,
            row['email'] as String));
  }

  @override
  Stream<List<String>> findAllProveedorNombre() {
    return _queryAdapter.queryListStream('SELECT nombreEmpresa FROM Proveedor',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Proveedor',
        isView: false);
  }

  @override
  Stream<Proveedor?> findProveedorById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM Proveedor WHERE cif = ?1',
        mapper: (Map<String, Object?> row) => Proveedor(
            row['cif'] as String,
            row['nombreEmpresa'] as String,
            row['numero'] as int,
            row['email'] as String),
        arguments: [id],
        queryableName: 'Proveedor',
        isView: false);
  }

  @override
  Future<void> insertProveedor(Proveedor proveedor) async {
    await _proveedorInsertionAdapter.insert(
        proveedor, OnConflictStrategy.abort);
  }
}

class _$PedidoDao extends PedidoDao {
  _$PedidoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _pedidoInsertionAdapter = InsertionAdapter(
            database,
            'Pedido',
            (Pedido item) => <String, Object?>{
                  'cifProveedor': item.cifProveedor,
                  'producto': item.producto,
                  'unidades': item.unidades,
                  'costeFinal': item.costeFinal,
                  'fecha': item.fecha
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Pedido> _pedidoInsertionAdapter;

  @override
  Future<List<Pedido>> findAllPedidos() async {
    return _queryAdapter.queryList('SELECT * FROM Pedido',
        mapper: (Map<String, Object?> row) => Pedido(
            row['producto'] as String,
            row['unidades'] as int,
            row['costeFinal'] as double,
            row['fecha'] as String,
            row['cifProveedor'] as String));
  }

  @override
  Stream<List<String>> findAllPedidoNombre() {
    return _queryAdapter.queryListStream('SELECT producto FROM Pedido',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Pedido',
        isView: false);
  }

  @override
  Stream<Pedido?> findPedidoById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Pedido WHERE cifProveedor = ?1',
        mapper: (Map<String, Object?> row) => Pedido(
            row['producto'] as String,
            row['unidades'] as int,
            row['costeFinal'] as double,
            row['fecha'] as String,
            row['cifProveedor'] as String),
        arguments: [id],
        queryableName: 'Pedido',
        isView: false);
  }

  @override
  Future<void> insertPedido(Pedido pedido) async {
    await _pedidoInsertionAdapter.insert(pedido, OnConflictStrategy.abort);
  }
}

class _$StockDao extends StockDao {
  _$StockDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _stockInsertionAdapter = InsertionAdapter(
            database,
            'Stock',
            (Stock item) => <String, Object?>{
                  'productoId': item.productoId,
                  'producto': item.producto,
                  'unidades': item.unidades,
                  'uniConsumidas': item.uniConsumidas
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Stock> _stockInsertionAdapter;

  @override
  Future<List<Stock>> findAllStocks() async {
    return _queryAdapter.queryList('SELECT * FROM Stock',
        mapper: (Map<String, Object?> row) => Stock(
            row['producto'] as String,
            row['productoId'] as int,
            row['unidades'] as int,
            row['uniConsumidas'] as int));
  }

  @override
  Stream<List<String>> findAllStockNombre() {
    return _queryAdapter.queryListStream('SELECT producto FROM Stock',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Stock',
        isView: false);
  }

  @override
  Stream<Stock?> findStockById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Stock WHERE productoId = ?1',
        mapper: (Map<String, Object?> row) => Stock(
            row['producto'] as String,
            row['productoId'] as int,
            row['unidades'] as int,
            row['uniConsumidas'] as int),
        arguments: [id],
        queryableName: 'Stock',
        isView: false);
  }

  @override
  Future<void> insertStock(Stock stock) async {
    await _stockInsertionAdapter.insert(stock, OnConflictStrategy.abort);
  }
}

class _$MermaDao extends MermaDao {
  _$MermaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _mermaInsertionAdapter = InsertionAdapter(
            database,
            'Merma',
            (Merma item) => <String, Object?>{
                  'productoId': item.productoId,
                  'producto': item.producto,
                  'unidades': item.unidades,
                  'fecha': item.fecha
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Merma> _mermaInsertionAdapter;

  @override
  Future<List<Merma>> findAllMermas() async {
    return _queryAdapter.queryList('SELECT * FROM Merma',
        mapper: (Map<String, Object?> row) => Merma(
            row['producto'] as String,
            row['productoId'] as int,
            row['unidades'] as int,
            row['fecha'] as String));
  }

  @override
  Stream<List<String>> findAllMermaNombre() {
    return _queryAdapter.queryListStream('SELECT producto FROM Merma',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Merma',
        isView: false);
  }

  @override
  Stream<Merma?> findMermaById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Merma WHERE productoId = ?1',
        mapper: (Map<String, Object?> row) => Merma(
            row['producto'] as String,
            row['productoId'] as int,
            row['unidades'] as int,
            row['fecha'] as String),
        arguments: [id],
        queryableName: 'Merma',
        isView: false);
  }

  @override
  Future<void> insertMerma(Merma merma) async {
    await _mermaInsertionAdapter.insert(merma, OnConflictStrategy.abort);
  }
}

class _$TrabajadorDao extends TrabajadorDao {
  _$TrabajadorDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _trabajadorInsertionAdapter = InsertionAdapter(
            database,
            'Trabajador',
            (Trabajador item) => <String, Object?>{
                  'dni': item.dni,
                  'nombre': item.nombre,
                  'numeroTlf': item.numeroTlf,
                  'horas': item.horas,
                  'precioHora': item.precioHora,
                  'puesto': item.puesto
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Trabajador> _trabajadorInsertionAdapter;

  @override
  Future<List<Trabajador>> findAllTrabajadors() async {
    return _queryAdapter.queryList('SELECT * FROM Trabajador',
        mapper: (Map<String, Object?> row) => Trabajador(
            row['dni'] as String,
            row['nombre'] as String,
            row['numeroTlf'] as String,
            row['horas'] as int,
            row['precioHora'] as double,
            row['puesto'] as String));
  }

  @override
  Stream<List<String>> findAllTrabajadorNombre() {
    return _queryAdapter.queryListStream('SELECT nombre FROM Trabajador',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Trabajador',
        isView: false);
  }

  @override
  Stream<Trabajador?> findTrabajadorById(String id) {
    return _queryAdapter.queryStream('SELECT * FROM Trabajador WHERE dni = ?1',
        mapper: (Map<String, Object?> row) => Trabajador(
            row['dni'] as String,
            row['nombre'] as String,
            row['numeroTlf'] as String,
            row['horas'] as int,
            row['precioHora'] as double,
            row['puesto'] as String),
        arguments: [id],
        queryableName: 'Trabajador',
        isView: false);
  }

  @override
  Future<void> insertTrabajador(Trabajador trabajador) async {
    await _trabajadorInsertionAdapter.insert(
        trabajador, OnConflictStrategy.abort);
  }
}

class _$AccesoPuestoDao extends AccesoPuestoDao {
  _$AccesoPuestoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _accesoPuestoInsertionAdapter = InsertionAdapter(
            database,
            'AccesoPuesto',
            (AccesoPuesto item) => <String, Object?>{
                  'trabajadorDni': item.trabajadorDni,
                  'puesto': item.puesto,
                  'accesibilidad': item.accesibilidad
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AccesoPuesto> _accesoPuestoInsertionAdapter;

  @override
  Future<List<AccesoPuesto>> findAllAccesoPuestos() async {
    return _queryAdapter.queryList('SELECT * FROM AccesoPuesto',
        mapper: (Map<String, Object?> row) => AccesoPuesto(
            row['trabajadorDni'] as String,
            row['puesto'] as String,
            row['accesibilidad'] as String));
  }

  @override
  Stream<List<String>> findAllAccesoPuestoNombre() {
    return _queryAdapter.queryListStream('SELECT puesto FROM AccesoPuesto',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'AccesoPuesto',
        isView: false);
  }

  @override
  Stream<AccesoPuesto?> findAccesoPuestoById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM AccesoPuesto WHERE trabajadorDni = ?1',
        mapper: (Map<String, Object?> row) => AccesoPuesto(
            row['trabajadorDni'] as String,
            row['puesto'] as String,
            row['accesibilidad'] as String),
        arguments: [id],
        queryableName: 'AccesoPuesto',
        isView: false);
  }

  @override
  Future<void> insertAccesoPuesto(AccesoPuesto accesoPuesto) async {
    await _accesoPuestoInsertionAdapter.insert(
        accesoPuesto, OnConflictStrategy.abort);
  }
}

class _$SeguridadSocialDao extends SeguridadSocialDao {
  _$SeguridadSocialDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _seguridadSocialInsertionAdapter = InsertionAdapter(
            database,
            'SeguridadSocial',
            (SeguridadSocial item) =>
                <String, Object?>{'puesto': item.puesto, 'paog': item.paog},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SeguridadSocial> _seguridadSocialInsertionAdapter;

  @override
  Future<List<SeguridadSocial>> findAllSeguridadSocials() async {
    return _queryAdapter.queryList('SELECT * FROM SeguridadSocial',
        mapper: (Map<String, Object?> row) =>
            SeguridadSocial(row['puesto'] as String, row['paog'] as int));
  }

  @override
  Stream<List<String>> findAllSeguridadSocialNombre() {
    return _queryAdapter.queryListStream('SELECT puesto FROM SeguridadSocial',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'SeguridadSocial',
        isView: false);
  }

  @override
  Stream<SeguridadSocial?> findSeguridadSocialById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM SeguridadSocial WHERE puesto = ?1',
        mapper: (Map<String, Object?> row) =>
            SeguridadSocial(row['puesto'] as String, row['paog'] as int),
        arguments: [id],
        queryableName: 'SeguridadSocial',
        isView: false);
  }

  @override
  Future<void> insertSeguridadSocial(SeguridadSocial seguridadSocial) async {
    await _seguridadSocialInsertionAdapter.insert(
        seguridadSocial, OnConflictStrategy.abort);
  }
}

class _$DetalleVentaDao extends DetalleVentaDao {
  _$DetalleVentaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _detalleVentaInsertionAdapter = InsertionAdapter(
            database,
            'DetalleVenta',
            (DetalleVenta item) => <String, Object?>{
                  'idVenta': item.idVenta,
                  'idProducto': item.idProducto,
                  'cantidad': item.cantidad,
                  'precioUnitario': item.precioUnitario,
                  'descuento': item.descuento,
                  'entregado': item.entregado ? 1 : 0
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DetalleVenta> _detalleVentaInsertionAdapter;

  @override
  Future<List<DetalleVenta>> findAllDetalleVentas() async {
    return _queryAdapter.queryList('SELECT * FROM DetalleVenta',
        mapper: (Map<String, Object?> row) => DetalleVenta(
            row['idVenta'] as int,
            row['idProducto'] as int,
            row['cantidad'] as int,
            row['precioUnitario'] as double,
            row['descuento'] as double,
            (row['entregado'] as int) != 0));
  }

  @override
  Stream<List<String>> findAllDetalleVentaNombre() {
    return _queryAdapter.queryListStream('SELECT producto FROM DetalleVenta',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'DetalleVenta',
        isView: false);
  }

  @override
  Stream<DetalleVenta?> findDetalleVentaById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM DetalleVenta WHERE idVenta = ?1',
        mapper: (Map<String, Object?> row) => DetalleVenta(
            row['idVenta'] as int,
            row['idProducto'] as int,
            row['cantidad'] as int,
            row['precioUnitario'] as double,
            row['descuento'] as double,
            (row['entregado'] as int) != 0),
        arguments: [id],
        queryableName: 'DetalleVenta',
        isView: false);
  }

  @override
  Future<void> insertDetalleVenta(DetalleVenta detalleVenta) async {
    await _detalleVentaInsertionAdapter.insert(
        detalleVenta, OnConflictStrategy.abort);
  }
}

class _$VentaDao extends VentaDao {
  _$VentaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _ventaInsertionAdapter = InsertionAdapter(
            database,
            'Venta',
            (Venta item) => <String, Object?>{
                  'idVenta': item.idVenta,
                  'costeTotal': item.costeTotal,
                  'ingresoTotal': item.ingresoTotal,
                  'idUsuario': item.idUsuario,
                  'nombreCliente': item.nombreCliente,
                  'fecha': item.fecha
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Venta> _ventaInsertionAdapter;

  @override
  Future<List<Venta>> findAllVentas() async {
    return _queryAdapter.queryList('SELECT * FROM Venta',
        mapper: (Map<String, Object?> row) => Venta(
            idVenta: row['idVenta'] as int,
            costeTotal: row['costeTotal'] as double,
            ingresoTotal: row['ingresoTotal'] as double,
            fecha: row['fecha'] as String,
            idUsuario: row['idUsuario'] as int,
            nombreCliente: row['nombreCliente'] as String));
  }

  @override
  Stream<List<String>> findAllVentaNombre() {
    return _queryAdapter.queryListStream('SELECT nombreCliente FROM Venta',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Venta',
        isView: false);
  }

  @override
  Stream<Venta?> findVentaById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Venta WHERE idVenta = ?1',
        mapper: (Map<String, Object?> row) => Venta(
            idVenta: row['idVenta'] as int,
            costeTotal: row['costeTotal'] as double,
            ingresoTotal: row['ingresoTotal'] as double,
            fecha: row['fecha'] as String,
            idUsuario: row['idUsuario'] as int,
            nombreCliente: row['nombreCliente'] as String),
        arguments: [id],
        queryableName: 'Venta',
        isView: false);
  }

  @override
  Future<void> insertVenta(Venta venta) async {
    await _ventaInsertionAdapter.insert(venta, OnConflictStrategy.abort);
  }
}

class _$CosteFijoDao extends CosteFijoDao {
  _$CosteFijoDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _costeFijoInsertionAdapter = InsertionAdapter(
            database,
            'CosteFijo',
            (CosteFijo item) =>
                <String, Object?>{'nombre': item.nombre, 'coste': item.coste},
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CosteFijo> _costeFijoInsertionAdapter;

  @override
  Future<List<CosteFijo>> findAllCosteFijos() async {
    return _queryAdapter.queryList('SELECT * FROM CosteFijo',
        mapper: (Map<String, Object?> row) => CosteFijo(
            nombre: row['nombre'] as String, coste: row['coste'] as double));
  }

  @override
  Stream<List<String>> findAllCosteFijoNombre() {
    return _queryAdapter.queryListStream('SELECT nombre FROM CosteFijo',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'CosteFijo',
        isView: false);
  }

  @override
  Stream<CosteFijo?> findCosteFijoById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM CosteFijo WHERE nombre = ?1',
        mapper: (Map<String, Object?> row) => CosteFijo(
            nombre: row['nombre'] as String, coste: row['coste'] as double),
        arguments: [id],
        queryableName: 'CosteFijo',
        isView: false);
  }

  @override
  Future<void> insertCosteFijo(CosteFijo costeFijo) async {
    await _costeFijoInsertionAdapter.insert(
        costeFijo, OnConflictStrategy.abort);
  }
}

class _$ClienteDao extends ClienteDao {
  _$ClienteDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _clienteInsertionAdapter = InsertionAdapter(
            database,
            'Cliente',
            (Cliente item) => <String, Object?>{
                  'nombreCliente': item.nombreCliente,
                  'telefono': item.telefono,
                  'email': item.email,
                  'puntos': item.puntos,
                  'nombreTienda': item.nombreTienda
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Cliente> _clienteInsertionAdapter;

  @override
  Future<List<Cliente>> findAllClientes() async {
    return _queryAdapter.queryList('SELECT * FROM Cliente',
        mapper: (Map<String, Object?> row) => Cliente(
            nombreCliente: row['nombreCliente'] as String,
            telefono: row['telefono'] as String,
            email: row['email'] as String,
            puntos: row['puntos'] as int,
            nombreTienda: row['nombreTienda'] as String));
  }

  @override
  Stream<List<String>> findAllClienteNombre() {
    return _queryAdapter.queryListStream('SELECT nombreCliente FROM Cliente',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Cliente',
        isView: false);
  }

  @override
  Stream<Cliente?> findClienteById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Cliente WHERE nombreCliente = ?1',
        mapper: (Map<String, Object?> row) => Cliente(
            nombreCliente: row['nombreCliente'] as String,
            telefono: row['telefono'] as String,
            email: row['email'] as String,
            puntos: row['puntos'] as int,
            nombreTienda: row['nombreTienda'] as String),
        arguments: [id],
        queryableName: 'Cliente',
        isView: false);
  }

  @override
  Future<void> insertCliente(Cliente cliente) async {
    await _clienteInsertionAdapter.insert(cliente, OnConflictStrategy.abort);
  }
}

class _$TiendaDao extends TiendaDao {
  _$TiendaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _tiendaInsertionAdapter = InsertionAdapter(
            database,
            'Tienda',
            (Tienda item) => <String, Object?>{
                  'nombreTienda': item.nombreTienda,
                  'nombreFiscal': item.nombreFiscal,
                  'ciudad': item.ciudad,
                  'codigoPostal': item.codigoPostal,
                  'direccion': item.direccion,
                  'telefono': item.telefono,
                  'email': item.email,
                  'logo': item.logo
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Tienda> _tiendaInsertionAdapter;

  @override
  Future<List<Tienda>> findAllTiendas() async {
    return _queryAdapter.queryList('SELECT * FROM Tienda',
        mapper: (Map<String, Object?> row) => Tienda(
            nombreTienda: row['nombreTienda'] as String,
            nombreFiscal: row['nombreFiscal'] as String,
            ciudad: row['ciudad'] as String,
            codigoPostal: row['codigoPostal'] as String,
            direccion: row['direccion'] as String,
            telefono: row['telefono'] as String,
            email: row['email'] as String,
            logo: row['logo'] as String));
  }

  @override
  Stream<List<String>> findAllTiendaNombre() {
    return _queryAdapter.queryListStream('SELECT nombreTienda FROM Tienda',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Tienda',
        isView: false);
  }

  @override
  Stream<Tienda?> findTiendaById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Tienda WHERE nombreTienda = ?1',
        mapper: (Map<String, Object?> row) => Tienda(
            nombreTienda: row['nombreTienda'] as String,
            nombreFiscal: row['nombreFiscal'] as String,
            ciudad: row['ciudad'] as String,
            codigoPostal: row['codigoPostal'] as String,
            direccion: row['direccion'] as String,
            telefono: row['telefono'] as String,
            email: row['email'] as String,
            logo: row['logo'] as String),
        arguments: [id],
        queryableName: 'Tienda',
        isView: false);
  }

  @override
  Future<void> insertTienda(Tienda tienda) async {
    await _tiendaInsertionAdapter.insert(tienda, OnConflictStrategy.abort);
  }
}

class _$EmpresaDao extends EmpresaDao {
  _$EmpresaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _empresaInsertionAdapter = InsertionAdapter(
            database,
            'Empresa',
            (Empresa item) => <String, Object?>{
                  'nombreFiscal': item.nombreFiscal,
                  'nif': item.nif,
                  'ciudad': item.ciudad,
                  'direccion': item.direccion,
                  'codigoPostal': item.codigoPostal,
                  'telefono': item.telefono,
                  'email': item.email,
                  'pais': item.pais,
                  'idCliente': item.idCliente,
                  'nombreTienda': item.nombreTienda
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Empresa> _empresaInsertionAdapter;

  @override
  Future<List<Empresa>> findAllEmpresas() async {
    return _queryAdapter.queryList('SELECT * FROM Empresa',
        mapper: (Map<String, Object?> row) => Empresa(
            nombreFiscal: row['nombreFiscal'] as String,
            nif: row['nif'] as int,
            ciudad: row['ciudad'] as String,
            direccion: row['direccion'] as String,
            codigoPostal: row['codigoPostal'] as String,
            telefono: row['telefono'] as String,
            email: row['email'] as String,
            pais: row['pais'] as String,
            idCliente: row['idCliente'] as int,
            nombreTienda: row['nombreTienda'] as String));
  }

  @override
  Stream<List<String>> findAllEmpresaNombre() {
    return _queryAdapter.queryListStream('SELECT nombreFiscal FROM Empresa',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Empresa',
        isView: false);
  }

  @override
  Stream<Empresa?> findEmpresaById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Empresa WHERE nombreFiscal = ?1',
        mapper: (Map<String, Object?> row) => Empresa(
            nombreFiscal: row['nombreFiscal'] as String,
            nif: row['nif'] as int,
            ciudad: row['ciudad'] as String,
            direccion: row['direccion'] as String,
            codigoPostal: row['codigoPostal'] as String,
            telefono: row['telefono'] as String,
            email: row['email'] as String,
            pais: row['pais'] as String,
            idCliente: row['idCliente'] as int,
            nombreTienda: row['nombreTienda'] as String),
        arguments: [id],
        queryableName: 'Empresa',
        isView: false);
  }

  @override
  Future<void> insertEmpresa(Empresa empresa) async {
    await _empresaInsertionAdapter.insert(empresa, OnConflictStrategy.abort);
  }
}

class _$ClienteJARVDao extends ClienteJARVDao {
  _$ClienteJARVDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _clienteJARVInsertionAdapter = InsertionAdapter(
            database,
            'ClienteJARV',
            (ClienteJARV item) => <String, Object?>{
                  'idCliente': item.idCliente,
                  'email': item.email,
                  'contrasena': item.contrasena,
                  'tipoSuscripcion': item.tipoSuscripcion
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ClienteJARV> _clienteJARVInsertionAdapter;

  @override
  Future<List<ClienteJARV>> findAllClienteJARVs() async {
    return _queryAdapter.queryList('SELECT * FROM ClienteJARV',
        mapper: (Map<String, Object?> row) => ClienteJARV(
            idCliente: row['idCliente'] as int,
            email: row['email'] as String,
            contrasena: row['contrasena'] as String,
            tipoSuscripcion: row['tipoSuscripcion'] as String));
  }

  @override
  Stream<List<String>> findAllClienteJARVEmail() {
    return _queryAdapter.queryListStream('SELECT email FROM ClienteJARV',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'ClienteJARV',
        isView: false);
  }

  @override
  Stream<ClienteJARV?> findClienteJARVById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM ClienteJARV WHERE idCliente = ?1',
        mapper: (Map<String, Object?> row) => ClienteJARV(
            idCliente: row['idCliente'] as int,
            email: row['email'] as String,
            contrasena: row['contrasena'] as String,
            tipoSuscripcion: row['tipoSuscripcion'] as String),
        arguments: [id],
        queryableName: 'ClienteJARV',
        isView: false);
  }

  @override
  Future<void> insertClienteJARV(ClienteJARV clienteJARV) async {
    await _clienteJARVInsertionAdapter.insert(
        clienteJARV, OnConflictStrategy.abort);
  }
}

class _$ImpuestosDao extends ImpuestosDao {
  _$ImpuestosDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _impuestosInsertionAdapter = InsertionAdapter(
            database,
            'Impuestos',
            (Impuestos item) => <String, Object?>{
                  'impuesto': item.impuesto,
                  'cantidad': item.cantidad
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Impuestos> _impuestosInsertionAdapter;

  @override
  Future<List<Impuestos>> findAllImpuestoss() async {
    return _queryAdapter.queryList('SELECT * FROM Impuestos',
        mapper: (Map<String, Object?> row) => Impuestos(
            impuesto: row['impuesto'] as String,
            cantidad: row['cantidad'] as double));
  }

  @override
  Stream<List<String>> findAllImpuestosNombre() {
    return _queryAdapter.queryListStream('SELECT impuesto FROM Impuestos',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Impuestos',
        isView: false);
  }

  @override
  Stream<Impuestos?> findImpuestosById(String id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Impuestos WHERE impuesto = ?1',
        mapper: (Map<String, Object?> row) => Impuestos(
            impuesto: row['impuesto'] as String,
            cantidad: row['cantidad'] as double),
        arguments: [id],
        queryableName: 'Impuestos',
        isView: false);
  }

  @override
  Future<void> insertImpuestos(Impuestos impuestos) async {
    await _impuestosInsertionAdapter.insert(
        impuestos, OnConflictStrategy.abort);
  }
}

class _$UsuarioDao extends UsuarioDao {
  _$UsuarioDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _usuarioInsertionAdapter = InsertionAdapter(
            database,
            'Usuario',
            (Usuario item) => <String, Object?>{
                  'nombre': item.nombre,
                  'idUsuario': item.idUsuario,
                  'contrasena': item.contrasena,
                  'nombreTienda': item.nombreTienda
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Usuario> _usuarioInsertionAdapter;

  @override
  Future<List<Usuario>> findAllUsuarios() async {
    return _queryAdapter.queryList('SELECT * FROM Usuario',
        mapper: (Map<String, Object?> row) => Usuario(
            nombre: row['nombre'] as String,
            idUsuario: row['idUsuario'] as int,
            contrasena: row['contrasena'] as String,
            nombreTienda: row['nombreTienda'] as String));
  }

  @override
  Stream<List<String>> findAllUsuarioNombre() {
    return _queryAdapter.queryListStream(
        'SELECT nombre, idUsuario FROM Usuario',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Usuario',
        isView: false);
  }

  @override
  Stream<Usuario?> findUsuarioById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM Usuario WHERE idUsuario = ?1',
        mapper: (Map<String, Object?> row) => Usuario(
            nombre: row['nombre'] as String,
            idUsuario: row['idUsuario'] as int,
            contrasena: row['contrasena'] as String,
            nombreTienda: row['nombreTienda'] as String),
        arguments: [id],
        queryableName: 'Usuario',
        isView: false);
  }

  @override
  Stream<Usuario?> findPasswordByUser(String nombre) {
    return _queryAdapter.queryStream(
        'SELECT contrasena FROM Usuario WHERE nombre = ?1',
        mapper: (Map<String, Object?> row) => Usuario(
            nombre: row['nombre'] as String,
            idUsuario: row['idUsuario'] as int,
            contrasena: row['contrasena'] as String,
            nombreTienda: row['nombreTienda'] as String),
        arguments: [nombre],
        queryableName: 'Usuario',
        isView: false);
  }

  @override
  Future<void> insertUsuario(Usuario usuario) async {
    await _usuarioInsertionAdapter.insert(usuario, OnConflictStrategy.abort);
  }
}

class _$OfertaDao extends OfertaDao {
  _$OfertaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _ofertaInsertionAdapter = InsertionAdapter(
            database,
            'Oferta',
            (Oferta item) => <String, Object?>{
                  'idOferta': item.idOferta,
                  'nombre': item.nombre,
                  'precio': item.precio,
                  'coste': item.coste
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Oferta> _ofertaInsertionAdapter;

  @override
  Future<List<Oferta>> findAllOfertas() async {
    return _queryAdapter.queryList('SELECT * FROM Oferta',
        mapper: (Map<String, Object?> row) => Oferta(
            idOferta: row['idOferta'] as int,
            nombre: row['nombre'] as String,
            precio: row['precio'] as double,
            coste: row['coste'] as double));
  }

  @override
  Stream<List<String>> findAllOfertaNombre() {
    return _queryAdapter.queryListStream('SELECT nombre, idOferta FROM Oferta',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'Oferta',
        isView: false);
  }

  @override
  Stream<Oferta?> findOfertaById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Oferta WHERE idOferta = ?1',
        mapper: (Map<String, Object?> row) => Oferta(
            idOferta: row['idOferta'] as int,
            nombre: row['nombre'] as String,
            precio: row['precio'] as double,
            coste: row['coste'] as double),
        arguments: [id],
        queryableName: 'Oferta',
        isView: false);
  }

  @override
  Future<void> insertOferta(Oferta oferta) async {
    await _ofertaInsertionAdapter.insert(oferta, OnConflictStrategy.abort);
  }
}

class _$ProductoOfertaDao extends ProductoOfertaDao {
  _$ProductoOfertaDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _productoOfertaInsertionAdapter = InsertionAdapter(
            database,
            'ProductoOferta',
            (ProductoOferta item) => <String, Object?>{
                  'idOferta': item.idOferta,
                  'idProducto': item.idProducto,
                  'cantidad': item.cantidad,
                  'unidades': item.unidades
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductoOferta> _productoOfertaInsertionAdapter;

  @override
  Future<List<ProductoOferta>> findAllProductoOfertas() async {
    return _queryAdapter.queryList('SELECT * FROM ProductoOferta',
        mapper: (Map<String, Object?> row) => ProductoOferta(
            idOferta: row['idOferta'] as int,
            idProducto: row['idProducto'] as int,
            cantidad: row['cantidad'] as int,
            unidades: row['unidades'] as int));
  }

  @override
  Stream<List<String>> findAllProductoOfertaId() {
    return _queryAdapter.queryListStream(
        'SELECT idOferta, idProducto FROM ProductoOferta',
        mapper: (Map<String, Object?> row) => row.values.first as String,
        queryableName: 'ProductoOferta',
        isView: false);
  }

  @override
  Stream<ProductoOferta?> findProductoOfertaById(int id) {
    return _queryAdapter.queryStream(
        'SELECT * FROM ProductoOferta WHERE idOferta = ?1',
        mapper: (Map<String, Object?> row) => ProductoOferta(
            idOferta: row['idOferta'] as int,
            idProducto: row['idProducto'] as int,
            cantidad: row['cantidad'] as int,
            unidades: row['unidades'] as int),
        arguments: [id],
        queryableName: 'ProductoOferta',
        isView: false);
  }

  @override
  Future<void> insertProductoOferta(ProductoOferta productoOferta) async {
    await _productoOfertaInsertionAdapter.insert(
        productoOferta, OnConflictStrategy.abort);
  }
}
