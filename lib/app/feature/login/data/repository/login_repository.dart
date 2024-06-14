import 'package:jarv/app/feature/login/data/model/entity_login.dart';
import 'package:jarv/app/feature/login/data/repository/interface/login_repository.dart';
import 'package:jarv/shared/data/database.dart';

class LoginRepositoryImpl extends LoginRepository {
  final AppDatabase _appDatabase;

  LoginRepositoryImpl(this._appDatabase);

  @override
  Future<List<Usuario>> findAllUsuarios() {
    return _appDatabase.usuarioDao.findAllUsuarios();
  }


}
