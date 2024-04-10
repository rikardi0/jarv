import 'package:jarv/app/feature/proveedor/data/model/entity_proveedor.dart';

abstract class ProveedorRepository {
  Future<List<Proveedor>> findAllProveedores();
  Future<void> insertProveedor(Proveedor proveedor);
}
