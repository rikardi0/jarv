import '../../../../../../shared/data/model/entity.dart';

abstract class InventarioRepository {
  Future<List<Familia>> findAllFamilias();
  Future<void> insertFamilia(Familia familia);
  Future<void> updateFamilia(Familia familia);

  Future<List<SubFamilia>> findAllSubFamilias();
  Future<List<SubFamilia?>> findSubFamiliaByFamilia(String id);
  Future<void> insertSubFamilia(SubFamilia subfamilia);
  Future<void> updateSubFamilia(SubFamilia subfamilia);

  Future<List<Producto?>> findProductoBySubFamiliaId(String id);
  Future<List<Producto>> findAllProductos();
  Future<void> insertProducto(Producto producto);
  Future<void> updateProducto(Producto producto);
}
