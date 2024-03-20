import 'package:floor/floor.dart';

class Familia {
  @primaryKey
  final String idFamilia;

  final String nombreFamilia;
  @primaryKey
  final String idUsuario;

  Familia(this.idFamilia, this.nombreFamilia, this.idUsuario);
}

@entity
class SubFamilia {
  @primaryKey
  final String idSubfamilia;

  final String nombreSub;

  final String idFamilia;

  SubFamilia(this.idSubfamilia, this.nombreSub, this.idFamilia);
}

@entity
class Producto {
  @primaryKey
  final int productoId;

  final String producto;

  final double precio;

  final int medida;

  final double coste;

  final double iva;

  final String idSubfamilia;

  Producto(this.productoId, this.producto, this.precio, this.coste, this.iva,
      this.idSubfamilia, this.medida);
}

@entity
class Cliente {
  @primaryKey
  final String nombreCliente;
  final String direccion;
  final String nif;
  final String fechaNacimiento;

  final String telefono;
  final String email;
  final int puntos;

  @primaryKey
  final String nombreTienda;

  Cliente({
    required this.fechaNacimiento,
    required this.nif,
    required this.direccion,
    required this.nombreCliente,
    required this.telefono,
    required this.email,
    required this.puntos,
    required this.nombreTienda,
  });
}

@entity
class DetalleVenta {
  @primaryKey
  final String idDetalleVenta;

  final int idVenta;

  final int productoId;

  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final bool entregado;

  DetalleVenta(this.idVenta, this.productoId, this.cantidad,
      this.precioUnitario, this.descuento, this.entregado, this.idDetalleVenta);
}

@entity
class Venta {
  @primaryKey
  final int idVenta;

  final bool consumicionPropia;
  final String metodoPago;
  final double costeTotal;
  final double ingresoTotal;

  @primaryKey
  final int idUsuario;
  final String nombreCliente;
  final String fecha;

  Venta({
    required this.consumicionPropia,
    required this.idVenta,
    required this.metodoPago,
    required this.costeTotal,
    required this.ingresoTotal,
    required this.fecha,
    required this.idUsuario,
    required this.nombreCliente,
  });
}
