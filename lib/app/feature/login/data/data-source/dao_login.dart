import 'package:floor/floor.dart';

import '../model/entity_login.dart';

@dao
abstract class UsuarioDao {
  @Query('SELECT * FROM Usuario')
  Future<List<Usuario>> findAllUsuarios();

  @Query('SELECT nombre, idUsuario FROM Usuario')
  Stream<List<String>> findAllUsuarioNombre();

  @Query('SELECT * FROM Usuario WHERE idUsuario = :id')
  Stream<Usuario?> findUsuarioById(int id);

  @Query('SELECT contrasena FROM Usuario WHERE nombre = :nombre')
  Stream<Usuario?> findPasswordByUser(String nombre);

  @insert
  Future<void> insertUsuario(Usuario usuario);
}
