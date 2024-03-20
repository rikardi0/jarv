import 'package:floor/floor.dart';

@entity
class Usuario {
  @primaryKey
  final String nombre;

  @primaryKey
  final int idUsuario;
  final String contrasena;

  @primaryKey
  final String nombreTienda;

  Usuario({
    required this.nombre,
    required this.idUsuario,
    required this.contrasena,
    required this.nombreTienda,
  });
}
