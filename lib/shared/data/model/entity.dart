import 'package:floor/floor.dart';

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
class Familia {
  @primaryKey
  final String idFamilia;

  final String nombreFamilia;
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
  final String idReceta;

  final double precio;

  final int medida;

  final double coste;

  final double iva;

  final String idSubfamilia;

  Producto({required this.productoId,
    required this.producto,
    required this.precio,
    required this.coste,
    required this.iva,
    required this.idSubfamilia,
    required this.medida,
    required this.idReceta});
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

@entity
class Ingrediente {
  @primaryKey
  final String idIngrediente;
  final String nombreIngrediente;
  final String medida;
  final double precio;
  final double unidadesCompradas;

  Ingrediente({
    required this.idIngrediente,
    required this.nombreIngrediente,
    required this.medida,
    required this.precio,
    required this.unidadesCompradas,
  });
}

@entity
class Receta {
  @primaryKey
  final String idReceta;
  final String nombreReceta;
  final double coste;

  Receta({
    required this.idReceta,
    required this.nombreReceta,
    required this.coste,
  });
}

@entity
class IngredienteReceta {
  @primaryKey
  final int idIngredienteReceta;

  //fk Ingrediente
  final String idIngrediente;

  //fk Receta
  final String idReceta;
  final String medida;
  final int cantidad;

  IngredienteReceta({
    required this.medida,
    required this.idIngrediente,
    required this.idIngredienteReceta,
    required this.idReceta,
    required this.cantidad,
  });
}
