import 'package:flutter/material.dart';
import 'package:jarv/app/feature/venta/data/model/arguments_cliente.dart';
import 'package:jarv/app/feature/venta/data/model/entity_venta.dart';
import 'package:jarv/app/feature/venta/data/repositories/interfaces/cliente_repository.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/utils/date_format.dart';
import 'package:jarv/shared/ui/utils/validators.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';

class ClienteField extends StatefulWidget {
  const ClienteField({super.key});

  static const routeName = '/cliente_field';

  @override
  State<ClienteField> createState() => _ClienteFieldState();
}

class _ClienteFieldState extends State<ClienteField> {
  final fetchRepository = localService<ClienteRepository>();
  DateTime? fecha = DateTime.now();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _nifController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _telefonoController = TextEditingController();

  final TextEditingController _ptsController = TextEditingController();

  final TextEditingController _pedidosController = TextEditingController();

  final TextEditingController _fechaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final ClienteArgument argument =
        ModalRoute.of(context)?.settings.arguments as ClienteArgument;

    setField(_nameController, argument.nombreCliente);
    setField(_nifController, argument.nif);
    setField(_emailController, argument.email);
    setField(_telefonoController, argument.telefono);
    setField(_fechaController, argument.fechaNacimiento);
    setField(_ptsController, argument.puntos.toString());
    setField(_pedidosController, argument.pedidos.toString());

    String fechaHint = fechaFormatter(fecha!);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (!didPop) {
          Navigator.pushReplacementNamed(context, '/cliente');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              argument.clienteNuevo ? 'Nuevo Cliente' : 'Modificar Cliente'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SafeArea(
                        child: SingleChildScrollView(
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Padding(
                              padding: const EdgeInsets.only(right: 40.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: CustomTextField(
                                                validateAction: (String value) {
                                                  return emptyValidator(value);
                                                },
                                                label: 'Nombre Cliente',
                                                value: argument.nombreCliente,
                                                controller: _nameController,
                                                keyboard: TextInputType.name)),
                                        SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.15,
                                            child: CustomTextField(
                                                validateAction: (String value) {
                                                  return emptyValidator(value);
                                                },
                                                label: 'NIF',
                                                value: argument.nif,
                                                controller: _nifController,
                                                keyboard: TextInputType.number))
                                      ],
                                    ),
                                    CustomTextField(
                                        validateAction: (String value) {
                                          return emptyValidator(value);
                                        },
                                        label: 'Correo',
                                        value: argument.email,
                                        controller: _emailController,
                                        keyboard: TextInputType.emailAddress),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _buildNacimientoPicker(
                                            argument, context, fechaHint),
                                        Expanded(
                                            child: CustomTextField(
                                                validateAction: (String value) {
                                                  return emptyValidator(value);
                                                },
                                                label: 'Telefono',
                                                value: argument.telefono,
                                                controller: _telefonoController,
                                                keyboard: TextInputType.phone)),
                                      ],
                                    ),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: CustomTextField(
                                            validateAction: (String value) {
                                              return emptyValidator(value);
                                            },
                                            label: 'Pts Acumulados',
                                            value: argument.puntos.toString(),
                                            controller: _ptsController,
                                            keyboard: TextInputType.number)),
                                    SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        child: CustomTextField(
                                            validateAction: (String value) {
                                              return emptyValidator(value);
                                            },
                                            label: 'Pedidos',
                                            value: argument.pedidos.toString(),
                                            controller: _pedidosController,
                                            keyboard: TextInputType.number)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    _buildImageContainer(context)
                  ],
                ),
              ),
              _buildActionButton(argument)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(ClienteArgument argument) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
            onPressed: () async {},
            icon: const Icon(Icons.print_rounded),
            label: const Text('Generar Factura')),
        FilledButton.icon(
            onPressed: () {
              if (!argument.clienteNuevo) {
                if (_formKey.currentState!.validate()) {
                  fetchRepository.updateCliente(setCliente(argument));
                  Navigator.popAndPushNamed(context, '/cliente');
                }
              } else {
                if (_formKey.currentState!.validate()) {
                  fetchRepository.insertCliente(setCliente(argument));
                  Navigator.popAndPushNamed(context, '/cliente');
                }
              }
            },
            icon: const Icon(Icons.save),
            label: const Text('Guardar')),
      ],
    );
  }

  Cliente setCliente(ClienteArgument argument) {
    return Cliente(
        fechaNacimiento: fechaFormatter(fecha!),
        idCliente: argument.idCliente,
        genero: true,
        pedidos: int.parse(_pedidosController.text),
        nif: _nifController.text,
        direccion: argument.direccion,
        nombreCliente: _nameController.text,
        telefono: _telefonoController.text,
        email: _emailController.text,
        puntos: int.parse(_ptsController.text),
        nombreTienda: argument.nombreTienda);
  }

  Widget _buildImageContainer(BuildContext context) {
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
              child: FilledButton.tonal(
                  onPressed: () {}, child: const Text('Agregar Foto')),
            ),
          ],
        ),
      ),
    );
  }

  Expanded _buildNacimientoPicker(
      ClienteArgument argument, BuildContext context, String fechaHint) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          controller: _fechaController,
          readOnly: true,
          onTap: () async {
            fecha = await showDatePicker(
                context: context,
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                firstDate: DateTime(1950),
                lastDate: DateTime(2010));
            _fechaController.text = fechaFormatter(fecha!);
            setState(() {});
          },
          decoration: InputDecoration(
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            hintText: fechaHint,
            labelText: 'Fecha',
            suffixIcon: const Icon(Icons.calendar_month),
          ),
        ),
      ),
    );
  }
}

void setField(TextEditingController controller, String value) {
  if (controller.text.isEmpty) {
    setValue(controller, value);
  }
}

void setValue(TextEditingController controller, String value) {
  controller.text = value;
}
