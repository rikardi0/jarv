class ClienteArgument {
  ClienteArgument(
      {required this.fechaNacimiento,
      required this.idCliente,
      required this.clienteNuevo,
      required this.nif,
      required this.genero,
      required this.pedidos,
      required this.direccion,
      required this.nombreCliente,
      required this.telefono,
      required this.email,
      required this.puntos,
      required this.nombreTienda});

  String fechaNacimiento;
  String nif;
  String nombreTienda;
  String direccion;
  String nombreCliente;
  String telefono;
  String email;
  bool genero;

  int puntos;
  int idCliente;
  int pedidos;
  bool clienteNuevo;
  ClienteArgument.empty()
      : fechaNacimiento = '',
        genero = true,
        clienteNuevo = true,
        nif = '',
        direccion = '',
        nombreCliente = '',
        telefono = '',
        email = '',
        puntos = 0,
        pedidos = 0,
        idCliente = DateTime.now().microsecondsSinceEpoch,
        nombreTienda = '';
}
