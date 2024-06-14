import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/ui/view/login.dart';
import 'package:jarv/app/feature/login/ui/widget/step/administrador_view.dart';
import 'package:jarv/app/feature/login/ui/widget/step/empresa_registro.dart';
import 'package:jarv/app/feature/login/ui/widget/step/producto_registro.dart';
import 'package:jarv/app/feature/login/ui/widget/step/proveedor_registro.dart';
import 'package:jarv/app/feature/login/ui/widget/step/tienda_registro.dart';
import 'package:jarv/app/feature/login/ui/widget/step/usuario_view.dart';
import 'package:slide_to_act/slide_to_act.dart';

class PrimerRegistro extends StatefulWidget {
  const PrimerRegistro({Key? key}) : super(key: key);
  static const routeName = '/primer_registro';

  @override
  State<PrimerRegistro> createState() => _PrimerRegistroState();
}

class _PrimerRegistroState extends State<PrimerRegistro> {
  final TextEditingController nombreEmpresa = TextEditingController();
  final TextEditingController nifEmpresa = TextEditingController();
  final TextEditingController correoEmpresa = TextEditingController();
  final TextEditingController paisEmpresa = TextEditingController();
  final TextEditingController provinciaEmpresa = TextEditingController();
  final TextEditingController ciudadEmpresa = TextEditingController();
  final TextEditingController zipCodeEmpresa = TextEditingController();
  final TextEditingController phoneEmpresa = TextEditingController();
  final empresaFormKey = GlobalKey<FormState>();
  final TextEditingController nombreAdmin = TextEditingController();
  final TextEditingController passwordAdmin = TextEditingController();

  final adminFormKey = GlobalKey<FormState>();
  final TextEditingController nombreTienda = TextEditingController();
  final TextEditingController nifTienda = TextEditingController();
  final TextEditingController correoTienda = TextEditingController();
  final TextEditingController paisTienda = TextEditingController();
  final TextEditingController provinciaTienda = TextEditingController();
  final TextEditingController ciudadTienda = TextEditingController();
  final TextEditingController zipTienda = TextEditingController();
  final TextEditingController phoneTienda = TextEditingController();
  final tiendaFormKey = GlobalKey<FormState>();
  int position = 0;
  bool showButton = true;
  bool showStepper = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: showStepper ? null : const NeverScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    stepper(context),
                    centerIcon(),
                    slideButton(context),
                    showButton
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, LoginScreen.routeName);
                            },
                            child: const Text('Ir a menu'))
                        : const SizedBox.shrink()
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget stepper(BuildContext context) {
    return SafeArea(
      child: Visibility(
        visible: showStepper ? true : false,
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stepper(
            physics: const ClampingScrollPhysics(),
            controlsBuilder: (context, details) {
              return position == ProductoRegistro.positionStepper
                  ? const SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.tonal(
                          onPressed: () {
                            if (position != 0) {
                              changeStep(false);
                            }
                          },
                          child: const Text('Cancelar'),
                        ),
                        FilledButton(
                          onPressed: () {
                            if (position == EmpresaRegistro.positionStepper) {
                              if (empresaFormKey.currentState!.validate()) {
                                changeStep(true);
                              }
                            } else if (position ==
                                TiendaRegistro.positionStepper) {
                              if (tiendaFormKey.currentState!.validate()) {
                                changeStep(true);
                              }
                            } else if (position ==
                                AdminRegistro.positionStepper) {
                              if (adminFormKey.currentState!.validate()) {
                                changeStep(true);
                              }
                            }
                          },
                          child: const Text('Continuar'),
                        ),
                      ],
                    );
            },
            type: StepperType.horizontal,
            currentStep: position,
            onStepTapped: (index) {
              setState(() {
                position = index;
              });
            },
            steps: [
              step(
                  'Empresa',
                  EmpresaRegistro(
                    formKey: empresaFormKey,
                    nombreController: nombreEmpresa,
                    nifController: nifEmpresa,
                    correoController: correoEmpresa,
                    paisController: paisEmpresa,
                    provinciaController: provinciaEmpresa,
                    ciudadController: ciudadEmpresa,
                    codigoPostalController: zipCodeEmpresa,
                    telefonoController: phoneEmpresa,
                  ),
                  EmpresaRegistro.positionStepper),
              step(
                  'Tienda',
                  TiendaRegistro(
                    formKey: tiendaFormKey,
                    nombreController: nombreTienda,
                    nifController: nifTienda,
                    correoController: correoTienda,
                    paisController: paisTienda,
                    provinciaController: provinciaTienda,
                    ciudadController: ciudadTienda,
                    codigoPostalController: zipTienda,
                    telefonoController: phoneTienda,
                  ),
                  TiendaRegistro.positionStepper),
              step(
                  'Administrador',
                  AdminRegistro(
                    formKey: adminFormKey,
                    nombre: nombreAdmin,
                    password: passwordAdmin,
                  ),
                  AdminRegistro.positionStepper),
              step('Usuarios', const UsuarioRegistro(),
                  UsuarioRegistro.positionStepper),
              step('Producto', ProductoRegistro(
                continueAction: () {
                  setState(() {
                    position += 1;
                  });
                },
              ), ProductoRegistro.positionStepper),
              step('Proveedor', const ProveedorRegistro(),
                  ProveedorRegistro.positionStepper),
              step('Final', const Text('data'), 6),
            ],
          ),
        ),
      ),
    );
  }

  void changeStep(bool isSum) {
    setState(() {
      if (isSum) {
        if (position <= 5) {
          position += 1;
        }
      } else {
        if (position <= 5) {
          position -= 1;
        }
      }
    });
  }

  Step step(String title, Widget content, index) {
    return Step(
      state: position == index
          ? StepState.editing
          : position > index
              ? StepState.complete
              : StepState.indexed,
      title: Text(title),
      content: content,
      isActive: position > index ? true : false,
    );
  }

  Visibility centerIcon() {
    return Visibility(
      visible: !showStepper ? true : false,
      child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: showButton ? 1 : 0,
          child: Image.asset('assets/images/jarv.png')),
    );
  }

  Widget slideButton(BuildContext context) {
    return Visibility(
      visible: !showStepper ? true : false,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.35,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 500),
          opacity: showButton ? 1 : 0,
          child: SlideAction(
            text: 'Desliza para empezar',
            onSubmit: () {
              setState(() {
                showButton = false;
                Future.delayed(const Duration(milliseconds: 100), () {
                  setState(() {
                    showStepper = true;
                  });
                });
              });

              return null;
            },
            sliderButtonIconPadding: 5,
            height: 50,
            outerColor: Theme.of(context).cardColor,
            innerColor: Theme.of(context).colorScheme.outlineVariant,
            sliderButtonIcon: Icon(
              Icons.arrow_forward_ios_outlined,
              color: Theme.of(context).colorScheme.outline,
            ),
            textStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}
