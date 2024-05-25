import '../../../../../../shared/data/model/entity.dart';

abstract class MenuRepository {
  Future<List<Familia>> findAllFamilias();
  Future<List<SubFamilia?>> findSubFamiliaByFamilia(String familiaId);
  Future<List<Producto?>> findProductoById(String subFamiliaId);
}
