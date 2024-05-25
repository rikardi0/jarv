import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/ui/view/widget/image_picker.dart';
import 'package:jarv/shared/ui/utils/validators.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';

class AdminRegistro extends StatefulWidget {
  const AdminRegistro({
    super.key,
    required this.formKey,
    required this.nombre,
    required this.password,
  });

  final GlobalKey<FormState> formKey;
  static int positionStepper = 2;
  final TextEditingController nombre;

  final TextEditingController password;

  @override
  State<AdminRegistro> createState() => _AdminRegistroState();
}

class _AdminRegistroState extends State<AdminRegistro> {
  bool hideText = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Usuario Administrador',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 8.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Text(
                      'El usuario administrador podra modificar todas las opciones y dar permisos a los nuevos usuarios.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CustomTextField(
                        validateAction: (String value) {
                          return emptyValidator(value);
                        },
                        label: 'Nombre',
                        value: widget.nombre.text,
                        controller: widget.nombre,
                        keyboard: TextInputType.name),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CustomTextField(
                        validateAction: (String value) {
                          return emptyValidator(value);
                        },
                        trailing: GestureDetector(
                          onTap: () {
                            setState(() {
                              hideText = !hideText;
                            });
                          },
                          child: Icon(hideText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                        ),
                        obscureText: hideText ? true : null,
                        label: 'Contraseña',
                        value: widget.password.text,
                        controller: widget.password,
                        keyboard: TextInputType.visiblePassword),
                  ),
                ),
              ],
            ),
          ),
          const ImagePicker(
            ratio: 0.5,
          )
        ],
      ),
    );
  }
}
