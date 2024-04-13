import '../../../../../../shared/data/model/entity.dart';

abstract class MenuRepository {
  Stream<List<Familia>> findAllFamilias();
  Stream<List<SubFamilia?>> findSubFamiliaByFamilia(String familiaId);
  Stream<List<Producto?>> findProductoById(String subFamiliaId);
}
