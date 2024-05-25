import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/ui/view/widget/image_picker.dart';
import 'package:jarv/shared/ui/utils/validators.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';

class RegistroInstitucion extends StatefulWidget {
  const RegistroInstitucion({
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
    required this.title,
    required this.content,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nombreController;

  final TextEditingController nifController;

  final TextEditingController correoController;

  final TextEditingController paisController;

  final TextEditingController provinciaController;

  final TextEditingController ciudadController;

  final TextEditingController codigoPostalController;

  final TextEditingController telefonoController;

  final String title;
  final String content;

  @override
  State<RegistroInstitucion> createState() => _RegistroInstitucionState();
}

class _RegistroInstitucionState extends State<RegistroInstitucion> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Registro ${widget.title}',
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: Text(
                widget.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          columnRegistro()
        ],
      ),
    );
  }

  Widget columnRegistro() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Form(
            key: widget.formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: buildName(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: buildRowNifEmail(context),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: buildRowZona(),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: buildRowZipPhone(),
                ),
              ],
            ),
          ),
        ),
        const ImagePicker(
          ratio: 0.5,
        )
      ],
    );
  }

  Widget buildName() {
    return CustomTextField(
        validateAction: (value) {
          return emptyValidator(value);
        },
        label: 'Nombre de la Empresa',
        value: widget.nombreController.text,
        controller: widget.nombreController,
        keyboard: TextInputType.name);
  }

  Widget buildRowZipPhone() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
              validateAction: (value) {
                return emptyValidator(value);
              },
              label: 'Codigo Postal',
              value: widget.codigoPostalController.text,
              controller: widget.codigoPostalController,
              keyboard: TextInputType.number),
        ),
        Expanded(
          child: CustomTextField(
              validateAction: (value) {
                return emptyValidator(value);
              },
              label: 'Telefono',
              value: widget.telefonoController.text,
              controller: widget.telefonoController,
              keyboard: TextInputType.phone),
        ),
      ],
    );
  }

  Widget buildRowZona() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
              validateAction: (value) {
                return emptyValidator(value);
              },
              label: 'Pais',
              value: widget.paisController.text,
              controller: widget.paisController,
              keyboard: TextInputType.name),
        ),
        Expanded(
          child: CustomTextField(
              validateAction: (value) {
                return emptyValidator(value);
              },
              label: 'Provincia',
              value: widget.provinciaController.text,
              controller: widget.provinciaController,
              keyboard: TextInputType.name),
        ),
        Expanded(
          child: CustomTextField(
              validateAction: (value) {
                return emptyValidator(value);
              },
              label: 'Ciudad',
              value: widget.ciudadController.text,
              controller: widget.ciudadController,
              keyboard: TextInputType.name),
        ),
      ],
    );
  }

  Widget buildRowNifEmail(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          child: CustomTextField(
              validateAction: (value) {
                return emptyValidator(value);
              },
              label: 'NIF',
              value: widget.nifController.text,
              controller: widget.nifController,
              keyboard: TextInputType.name),
        ),
        Expanded(
          child: CustomTextField(
              validateAction: (value) {
                return emptyValidator(value);
              },
              label: 'Correo',
              value: widget.correoController.text,
              controller: widget.correoController,
              keyboard: TextInputType.emailAddress),
        ),
      ],
    );
  }
}
