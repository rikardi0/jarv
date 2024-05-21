import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/ui/utils/validators.dart';
import 'package:jarv/shared/ui/custom_text_field.dart';

class AdminRegistro extends StatefulWidget {
  const AdminRegistro({
    super.key,
    required this.formKey,
  });

  final GlobalKey<FormState> formKey;

  @override
  State<AdminRegistro> createState() => _AdminRegistroState();
}

class _AdminRegistroState extends State<AdminRegistro> {
  final TextEditingController nombre = TextEditingController();
  final TextEditingController password = TextEditingController();
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
                          if (value.isEmpty) {
                            return emptyMessage;
                          }
                          return null;
                        },
                        label: 'Nombre',
                        value: nombre.text,
                        controller: nombre,
                        keyboard: TextInputType.name),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: CustomTextField(
                        validateAction: (String value) {
                          if (value.isEmpty) {
                            return emptyMessage;
                          }
                          return null;
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
                        value: password.text,
                        controller: password,
                        keyboard: TextInputType.visiblePassword),
                  ),
                ),
              ],
            ),
          ),
          buildImageLoader(context)
        ],
      ),
    );
  }

  SafeArea buildImageLoader(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              width: MediaQuery.of(context).size.height * 0.45,
              child: const Card(
                elevation: 15.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () {}, child: const Text('Agregar Foto')),
            ),
          ],
        ),
      ),
    );
  }
}
