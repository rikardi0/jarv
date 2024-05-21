import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/ui/view/widget/administrador_view.dart';
import 'package:jarv/app/feature/login/ui/view/widget/empresa_registro.dart';
import 'package:jarv/app/feature/login/ui/view/widget/producto_registro.dart';
import 'package:jarv/app/feature/login/ui/view/widget/proveedor_registro.dart';
import 'package:jarv/app/feature/login/ui/view/widget/tienda_registro.dart';
import 'package:jarv/app/feature/login/ui/view/widget/usuario_view.dart';
import 'package:slide_to_act/slide_to_act.dart';

class PrimerRegistro extends StatefulWidget {
  const PrimerRegistro({Key? key}) : super(key: key);
  static const routeName = '/primer_registro';

  @override
  State<PrimerRegistro> createState() => _PrimerRegistroState();
}

class _PrimerRegistroState extends State<PrimerRegistro> {
  final adminForm = GlobalKey<FormState>();
  int position = 0;
  bool showButton = true;
  bool showStepper = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    stepper(context),
                    centerIcon(),
                    slideButton(context)
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
            controlsBuilder: (context, details) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton.tonal(
                    onPressed: () {
                      setState(() {
                        if (position != 0) {
                          position -= 1;
                        }
                      });
                    },
                    child: const Text('Cancelar'),
                  ),
                  FilledButton(
                    onPressed: () {
                      if (adminForm.currentState!.validate()) {
                        setState(() {
                          if (position <= 5) {
                            position += 1;
                          }
                        });
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
                if (position >= index) {
                  position = index;
                }
              });
            },
            steps: [
              step(
                  'Administrador',
                  AdminRegistro(
                    formKey: adminForm,
                  ),
                  0),
              step('Usuario', const UsuarioRegistro(), 1),
              step('Empresa', const EmpresaRegistro(), 2),
              step('Tienda', const TiendaRegistro(), 3),
              step('Producto', const ProductoRegistro(), 4),
              step('Proveedor', const ProveedorRegistro(), 5),
              step('Final', const Text('data'), 6),
            ],
          ),
        ),
      ),
    );
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
