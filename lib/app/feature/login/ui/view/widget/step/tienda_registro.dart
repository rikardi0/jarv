import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/ui/view/widget/registro_institucion.dart';

class TiendaRegistro extends StatelessWidget {
  const TiendaRegistro({
    super.key,
    required this.formKey,
    required this.nombreController,
    required this.nifController,
    required this.correoController,
    required this.paisController,
    required this.provinciaController,
    required this.ciudadController,
    required this.codigoPostalController,
    required this.telefonoController,
  });

  final TextEditingController nombreController;
  final TextEditingController nifController;
  final TextEditingController correoController;
  final TextEditingController paisController;
  final TextEditingController provinciaController;
  final TextEditingController ciudadController;
  final TextEditingController codigoPostalController;
  final TextEditingController telefonoController;
  static int positionStepper = 1;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return RegistroInstitucion(
      formKey: formKey,
      nombreController: nombreController,
      nifController: nifController,
      correoController: correoController,
      paisController: paisController,
      provinciaController: provinciaController,
      ciudadController: ciudadController,
      codigoPostalController: codigoPostalController,
      telefonoController: telefonoController,
      title: 'Tienda',
      content:
          'Le denominamos Empresa a nivel jurídico, para poder crear facturas...',
    );
  }
}
