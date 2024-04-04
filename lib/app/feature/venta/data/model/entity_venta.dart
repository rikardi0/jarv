import 'package:floor/floor.dart';

@entity
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
  final int idCliente;

  final String nombreCliente;
  final String nombreTienda;
  final String direccion;
  final String nif;
  final String fechaNacimiento;
  final bool genero;

  final String telefono;
  final String email;
  final int puntos;
  final int pedidos;

  Cliente({
    required this.fechaNacimiento,
    required this.idCliente,
    required this.genero,
    required this.pedidos,
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

  DetalleVenta(
      {required this.idVenta,
      required this.productoId,
      required this.cantidad,
      required this.precioUnitario,
      required this.descuento,
      required this.entregado,
      required this.idDetalleVenta});
}

@entity
class Venta {
  @primaryKey
  final int idVenta;

  final String tipoVenta;

  final String metodoPago;
  final double costeTotal;
  final double ingresoTotal;

  @primaryKey
  final int idUsuario;
  final String nombreCliente;
  final String fecha;

  Venta({
    required this.tipoVenta,
    required this.idVenta,
    required this.metodoPago,
    required this.costeTotal,
    required this.ingresoTotal,
    required this.fecha,
    required this.idUsuario,
    required this.nombreCliente,
  });
}

@entity
class Devolucion {
  @primaryKey
  final int idDevolucion;
  final String devolucion;

  Devolucion({required this.idDevolucion, required this.devolucion});
}

@entity
class TipoVenta {
  @primaryKey
  final int idTipoVenta;

  final String tipoVenta;

  TipoVenta({required this.idTipoVenta, required this.tipoVenta});
}
