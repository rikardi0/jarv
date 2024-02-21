class ProductoPreOrdenado {
  ProductoPreOrdenado(
      {required this.productoId,
      required this.nombreProducto,
      required this.precio,
      required this.cantidad});

  final String productoId;
  final String nombreProducto;
  final double precio;
  String cantidad;

  ProductoPreOrdenado.actualizarCantidad(
    String productoId,
    String nombreProducto,
    double precio,
    String nuevaCantidad,
  ) : this(
          productoId: productoId,
          nombreProducto: nombreProducto,
          precio: precio,
          cantidad: nuevaCantidad,
        );
}
