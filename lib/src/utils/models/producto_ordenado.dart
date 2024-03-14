class ProductoOrdenado {
  ProductoOrdenado(
      {required this.productoId,
      required this.nombreProducto,
      required this.iva,
      required this.precio,
      required this.fecha,
      required this.cantidad});

  String productoId;
  String nombreProducto;
  DateTime fecha;
  double precio;
  double iva;
  String cantidad;
}
