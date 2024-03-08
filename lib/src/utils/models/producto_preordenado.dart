class ProductoPreOrdenado {
  ProductoPreOrdenado(
      {required this.productoId,
      required this.nombreProducto,
      required this.iva,
      required this.precio,
      required this.cantidad});

  String productoId;
  String nombreProducto;
  double precio;
  double iva;
  String cantidad;
}
