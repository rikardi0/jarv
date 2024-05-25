class ArgumentProveedor {
  final String nombreEmpresa;
  final String telefono;
  final String cif;
  final String correo;
  final Map<String, String> listaRubro;

  ArgumentProveedor(
      {required this.nombreEmpresa,
      required this.telefono,
      required this.cif,
      required this.correo,
      required this.listaRubro});

  ArgumentProveedor.empty()
      : cif = ' ',
        nombreEmpresa = '',
        telefono = '',
        correo = '',
        listaRubro = {};
}
