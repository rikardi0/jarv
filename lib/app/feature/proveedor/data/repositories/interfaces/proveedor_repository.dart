import 'package:jarv/app/feature/proveedor/data/model/entity_proveedor.dart';

import '../../../../../../shared/data/model/entity.dart';

abstract class ProveedorRepository {
  Future<List<Proveedor>> findAllProveedores();
  Stream<Familia?> findFamiliaById(String id);
  Future<void> insertProveedor(Proveedor proveedor);
}
