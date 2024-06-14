import 'package:jarv/app/feature/login/data/model/entity_login.dart';

abstract class LoginRepository {
  Future<List<Usuario>> findAllUsuarios();

}
