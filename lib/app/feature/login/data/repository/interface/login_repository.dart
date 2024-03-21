import '../../model/entity_login.dart';

abstract class LoginRepository {
  Future<List<Usuario>> findAllUsuarios();
}
