import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/data/repository/interface/login_repository.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/data/model/entity.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';

class RecetasView extends StatefulWidget {
  const RecetasView({Key? key}) : super(key: key);

  static const routeName = '/recetas_view';

  @override
  State<RecetasView> createState() => _RecetasViewState();
}

class _RecetasViewState extends State<RecetasView> {
  String? idSeleccionada;
  String? medidaSeleccionada;

  final fetchRepository = localService<LoginRepository>();
  final TextEditingController searchField = TextEditingController();
  final TextEditingController nombreIngrediente = TextEditingController();
  final TextEditingController cantidadIngrediente = TextEditingController();
  final TextEditingController medidaIngrediente = TextEditingController();
  final TextEditingController costeIngrediente = TextEditingController();
  final TextEditingController costoUnidad = TextEditingController();
  final TextEditingController cantidadIngredienteReceta =
      TextEditingController();
  final ValueNotifier<int?> selectedIngrediente = ValueNotifier<int?>(null);
  List<Ingrediente?> listIngrediente = [];
  List<Ingrediente?> listIngredienteReceta = [];

  bool isNewProduct = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColumnIngredientes(context),
          const VerticalDivider(),
          buildTableReceta(context),
        ],
      ),
    );
  }

  Padding buildTableReceta(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Nombre de Producto',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(color: Colors.black26))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    containerColumn('Formato'),
                    containerColumn('Medida'),
                    containerColumn('Cantidad'),
                    containerColumn('Coste'),
                    containerColumn('Rentabilidad'),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView.builder(
                  itemCount: listIngredienteReceta.length,
                  itemBuilder: (context, index) {
                    var item = listIngredienteReceta[index];
                    return Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.black26))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          containerColumn(item!.nombreIngrediente),
                          containerColumn(item.medida),
                          Expanded(
                            child: Row(
                              children: [
                                IconButton.outlined(
                                    iconSize: 15,
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      if (item.unidadesCompradas > 1) {
                                        cantidadButton(item, index, false);
                                      }
                                    },
                                    icon: const Icon(
                                        Icons.arrow_downward_outlined)),
                                containerColumn(
                                    item.unidadesCompradas.toString()),
                                IconButton.outlined(
                                    iconSize: 15,
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      cantidadButton(item, index, true);
                                    },
                                    icon: const Icon(
                                        Icons.arrow_upward_outlined)),
                              ],
                            ),
                          ),
                          containerColumn(item.precio.toString()),
                          Expanded(
                            child: Row(
                              children: [
                                containerColumn(item.nombreIngrediente),
                                IconButton(
                                    onPressed: () {
                                      setState(() {
                                        listIngredienteReceta.removeAt(index);
                                      });
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              listIngredienteReceta.isNotEmpty
                  ? ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          foregroundColor:
                              Theme.of(context).colorScheme.onTertiary),
                      onPressed: () {},
                      label: const Text('Agregar Receta'),
                      icon: const Icon(Icons.add_box),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        ),
      ),
    );
  }

  void cantidadButton(Ingrediente item, int index, bool isSuma) {
    setState(() {});

    double? cantidad;
    if (isSuma) {
      cantidad = item.unidadesCompradas + 1;
    } else {
      cantidad = item.unidadesCompradas - 1;
    }
    listIngredienteReceta[index] = Ingrediente(
        idIngrediente: item.idIngrediente,
        nombreIngrediente: item.nombreIngrediente,
        medida: item.medida,
        precio: item.precio,
        unidadesCompradas: cantidad);
  }

  Expanded containerColumn(String label) {
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        style: Theme.of(context).textTheme.titleMedium,
        label,
        textAlign: TextAlign.center,
      ),
    ));
  }

  Widget buildColumnIngredientes(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Ingredientes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomTextField(
                  label: 'Buscar',
                  trailing: const Icon(Icons.search),
                  value: searchField.text,
                  controller: searchField,
                  keyboard: TextInputType.text),
            ),
            Expanded(
              child: FutureBuilder(
                  future: fetchRepository.findAllIngredientes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      listIngrediente = snapshot.data!;
                      if (searchField.text.isNotEmpty) {
                        listIngrediente = listIngrediente.where((element) {
                          return element!.nombreIngrediente
                              .toString()
                              .toLowerCase()
                              .contains(
                                  searchField.text.toString().toLowerCase());
                        }).toList();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listIngrediente.length,
                          itemBuilder: (context, index) {
                            final ingrediente = listIngrediente[index];
                            return Column(
                              children: [
                                ListTile(
                                    onLongPress: () {
                                      setState(() {
                                        selectedIngrediente.value = index;
                                        idSeleccionada =
                                            ingrediente.idIngrediente;
                                        nombreIngrediente.text =
                                            ingrediente.nombreIngrediente;
                                        medidaIngrediente.text =
                                            ingrediente.medida.toString();
                                        cantidadIngrediente.text = ingrediente
                                            .unidadesCompradas
                                            .toString();
                                        costeIngrediente.text =
                                            ingrediente.precio.toString();
                                      });

                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return dialogCrearIngrediente(
                                              context, true);
                                        },
                                      );
                                    },
                                    onTap: () {
                                      setState(() {
                                        if (selectedIngrediente.value ==
                                            index) {
                                          selectedIngrediente.value = null;
                                          cantidadIngredienteReceta.clear();
                                        } else {
                                          medidaSeleccionada =
                                              ingrediente.medida;

                                          selectedIngrediente.value = index;
                                        }
                                      });
                                    },
                                    selectedColor:
                                        Theme.of(context).colorScheme.primary,
                                    selected: selectedIngrediente.value == index
                                        ? true
                                        : false,
                                    trailing:
                                        const Icon(Icons.food_bank_rounded),
                                    subtitle: Text(
                                        'disponible: ${ingrediente!.unidadesCompradas.toString()} '),
                                    title: Text(ingrediente.nombreIngrediente)),
                                index < listIngrediente.length - 1
                                    ? const Divider()
                                    : const SizedBox.shrink()
                              ],
                            );
                          },
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            selectedIngrediente.value != null
                ? FocusScope(
                    child: Focus(
                      onFocusChange: (focus) {
                        setState(() {
                          isNewProduct = focus;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: CustomTextField(
                            trailing: IconButton(
                                onPressed: () {
                                  cantidadIngredienteReceta.clear();
                                },
                                icon: const Icon(Icons.clear)),
                            label: medidaSeleccionada!,
                            value: cantidadIngredienteReceta.text,
                            controller: cantidadIngredienteReceta,
                            keyboard: TextInputType.number),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: !boolBtn() ? Colors.blueAccent : null,
                foregroundColor: !boolBtn() ? Colors.white : null,
              ),
              onPressed: () {
                if (boolBtn()) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return dialogCrearIngrediente(context, false);
                    },
                  );
                } else if (double.parse(cantidadIngredienteReceta.text) >
                    listIngrediente[selectedIngrediente.value!]!
                        .unidadesCompradas) {
                } else {
                  addIngredientToReceta(
                      listIngrediente[selectedIngrediente.value!]!);
                }
              },
              icon: Icon(!boolBtn() ? Icons.fastfood_rounded : Icons.add),
              label: Text('${!boolBtn() ? 'Añadir' : 'Nuevo'} Ingrediente'),
            )
          ],
        ),
      ),
    );
  }

  bool boolBtn() {
    return selectedIngrediente.value == null &&
        cantidadIngredienteReceta.text.isEmpty;
  }

  void addIngredientToReceta(Ingrediente item) {
    if (listIngredienteReceta
        .any((element) => element!.idIngrediente == item.idIngrediente)) {
      final itemTablaReceta = listIngredienteReceta
          .where((element) => element!.idIngrediente == item.idIngrediente);

      final double cantidad = itemTablaReceta.first!.unidadesCompradas +
          double.parse(cantidadIngredienteReceta.text);

      final position = listIngredienteReceta.indexOf(itemTablaReceta.first);

      listIngredienteReceta[position] = Ingrediente(
          idIngrediente: itemTablaReceta.first!.idIngrediente,
          nombreIngrediente: itemTablaReceta.first!.nombreIngrediente,
          medida: itemTablaReceta.first!.medida,
          precio: itemTablaReceta.first!.precio,
          unidadesCompradas: cantidad);
    } else {
      listIngredienteReceta.add(Ingrediente(
        idIngrediente: item.idIngrediente,
        nombreIngrediente: item.nombreIngrediente,
        medida: item.medida,
        precio: item.precio,
        unidadesCompradas: double.parse(cantidadIngredienteReceta.text),
      ));
    }

    setState(() {});
  }

  Dialog dialogCrearIngrediente(BuildContext context, bool isEdit) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.35,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomTextField(
                            label: 'Nombre del Ingrediente',
                            value: nombreIngrediente.text,
                            controller: nombreIngrediente,
                            keyboard: TextInputType.text),
                      ),
                      Visibility(
                        visible: isEdit,
                        child: FilledButton.tonalIcon(
                            style: FilledButton.styleFrom(
                                backgroundColor: Colors.transparent),
                            onPressed: () {
                              deleteIngrediente();
                              selectedIngrediente.value = null;
                              setState(() {});
                            },
                            label: const Icon(Icons.delete),
                            icon: const Text('Eliminar')),
                      )
                    ],
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              label: 'Medida',
                              value: medidaIngrediente.text,
                              controller: medidaIngrediente,
                              keyboard: TextInputType.text),
                        ),
                        Expanded(
                          child: CustomTextField(
                              label: 'Cantidad',
                              value: cantidadIngrediente.text,
                              controller: cantidadIngrediente,
                              keyboard: TextInputType.text),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                              label: 'Coste',
                              value: costeIngrediente.text,
                              controller: costeIngrediente,
                              keyboard: TextInputType.text),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar')),
                      FilledButton(
                          onPressed: () {
                            setState(() {
                              if (isEdit) {
                                updateIngrediente();
                              } else {
                                insertIngrediente();
                              }
                            });
                          },
                          child: const Text('Guardar')),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void deleteIngrediente() {
    fetchRepository.deleteIngrediente(idSeleccionada!);
    Navigator.pop(context);
  }

  void updateIngrediente() {
    fetchRepository.updateIngrediente(Ingrediente(
        idIngrediente: idSeleccionada!,
        nombreIngrediente: nombreIngrediente.text,
        medida: medidaIngrediente.text,
        precio: double.parse(costeIngrediente.text),
        unidadesCompradas: double.parse(cantidadIngrediente.text)));
    Navigator.pop(context);
  }

  void insertIngrediente() {
    fetchRepository.insertIngrediente(Ingrediente(
        idIngrediente: UniqueKey().toString(),
        nombreIngrediente: nombreIngrediente.text,
        medida: medidaIngrediente.text,
        precio: double.parse(costeIngrediente.text),
        unidadesCompradas: double.parse(cantidadIngrediente.text)));
    Navigator.pop(context);
  }
}
