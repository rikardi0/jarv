import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';

abstract class MenuRepository {
  Stream<List<Familia>> findAllFamilias();
  Stream<List<SubFamilia?>> findSubFamiliaByFamilia(String familiaId);
  Stream<List<Producto?>> findProductoById(String subFamiliaId);
}
