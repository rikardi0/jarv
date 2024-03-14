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
class Proveedor {
  @primaryKey
  final String cif;

  final String nombreEmpresa;

  final int numero;

  final String email;

  Proveedor(this.cif, this.nombreEmpresa, this.numero, this.email);
}

@entity
class Pedido {
  @primaryKey
  final String cifProveedor;

  final String producto;

  final int unidades;

  final double costeFinal;

  final String fecha;

  Pedido(this.producto, this.unidades, this.costeFinal, this.fecha,
      this.cifProveedor);
}

@entity
class Stock {
  @primaryKey
  final int productoId;

  final String producto;
  final int unidades;

  final int uniConsumidas;

  Stock(this.producto, this.productoId, this.unidades, this.uniConsumidas);
}

@entity
class Merma {
  @primaryKey
  final int productoId;
  final String producto;

  final int unidades;

  final String fecha;

  Merma(this.producto, this.productoId, this.unidades, this.fecha);
}

@entity
class Trabajador {
  @primaryKey
  final String dni;

  final String nombre;

  final String numeroTlf;

  final int horas;

  final double precioHora;

  final String puesto;

  Trabajador(this.dni, this.nombre, this.numeroTlf, this.horas, this.precioHora,
      this.puesto);
}

@entity
class AccesoPuesto {
  @primaryKey
  final String trabajadorDni;

  final String puesto;

  final String accesibilidad;

  AccesoPuesto(this.trabajadorDni, this.puesto, this.accesibilidad);
}

@entity
class SeguridadSocial {
  @primaryKey
  final String puesto;

  final int paog;

  SeguridadSocial(this.puesto, this.paog);
}

@entity
class DetalleVenta {

  final int idVenta;

  @primaryKey
  final int idProducto;

  final int cantidad;
  final double precioUnitario;
  final double descuento;
  final bool entregado;

  DetalleVenta(this.idVenta, this.idProducto, this.cantidad,
      this.precioUnitario, this.descuento, this.entregado);
}

@entity
class Venta {
  @primaryKey
  final int idVenta;

  final double costeTotal;
  final double ingresoTotal;

  @primaryKey
  final int idUsuario;
  final String nombreCliente;
  final String fecha;

  Venta({
    required this.idVenta,
    required this.costeTotal,
    required this.ingresoTotal,
    required this.fecha,
    required this.idUsuario,
    required this.nombreCliente,
  });
}

@entity
class CosteFijo {
  @primaryKey
  final String nombre;

  final double coste;

  CosteFijo({
    required this.nombre,
    required this.coste,
  });
}

@entity
class Cliente {
  @primaryKey
  final String nombreCliente;

  final String telefono;
  final String email;
  final int puntos;

  @primaryKey
  final String nombreTienda;

  Cliente({
    required this.nombreCliente,
    required this.telefono,
    required this.email,
    required this.puntos,
    required this.nombreTienda,
  });
}

@entity
class Tienda {
  @primaryKey
  final String nombreTienda;

  final String nombreFiscal;
  final String ciudad;
  final String codigoPostal;
  final String direccion;
  final String telefono;
  final String email;
  final String logo;

  Tienda({
    required this.nombreTienda,
    required this.nombreFiscal,
    required this.ciudad,
    required this.codigoPostal,
    required this.direccion,
    required this.telefono,
    required this.email,
    required this.logo,
  });
}

@entity
class Empresa {
  @primaryKey
  final String nombreFiscal;

  final int nif;
  final String ciudad;
  final String direccion;
  final String codigoPostal;
  final String telefono;
  final String email;
  final String pais;

  @primaryKey
  final int idCliente;

  @primaryKey
  final String nombreTienda;

  Empresa({
    required this.nombreFiscal,
    required this.nif,
    required this.ciudad,
    required this.direccion,
    required this.codigoPostal,
    required this.telefono,
    required this.email,
    required this.pais,
    required this.idCliente,
    required this.nombreTienda,
  });
}

@entity
class ClienteJARV {
  @primaryKey
  final int idCliente;

  final String email;
  final String contrasena;
  final String tipoSuscripcion;

  ClienteJARV({
    required this.idCliente,
    required this.email,
    required this.contrasena,
    required this.tipoSuscripcion,
  });
}

@entity
class Impuestos {
  @primaryKey
  final String impuesto;

  final double cantidad;

  Impuestos({
    required this.impuesto,
    required this.cantidad,
  });
}

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

@entity
class Oferta {
  @primaryKey
  final int idOferta;

  final String nombre;
  final double precio;
  final double coste;

  Oferta({
    required this.idOferta,
    required this.nombre,
    required this.precio,
    required this.coste,
  });
}

@entity
class ProductoOferta {
  @primaryKey
  final int idOferta;

  @primaryKey
  final int idProducto;
  final int cantidad;
  final int unidades;

  ProductoOferta({
    required this.idOferta,
    required this.idProducto,
    required this.cantidad,
    required this.unidades,
  });
}
