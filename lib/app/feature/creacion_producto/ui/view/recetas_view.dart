import 'package:flutter/material.dart';
import 'package:jarv/app/feature/creacion_producto/data/model/entity_creacion_producto.dart';
import 'package:jarv/app/feature/creacion_producto/data/repository/interface/creacion_producto_repository.dart';
import 'package:jarv/app/feature/creacion_producto/ui/provider/creacion_producto_provider.dart';
import 'package:jarv/app/feature/login/data/model/recetas_argument.dart';
import 'package:jarv/core/di/locator.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';
import 'package:jarv/shared/ui/widget/search_field.dart';
import 'package:provider/provider.dart';

class RecetasView extends StatefulWidget {
  const RecetasView({Key? key}) : super(key: key);

  static const routeName = '/recetas_view';

  @override
  State<RecetasView> createState() => _RecetasViewState();
}

class _RecetasViewState extends State<RecetasView> {
  final fetchRepository = localService<CreacionProductoRepository>();

  final TextEditingController searchField = TextEditingController();
  final TextEditingController nombreIngrediente = TextEditingController();
  final TextEditingController cantidadIngrediente = TextEditingController();
  final TextEditingController medidaIngrediente = TextEditingController();
  final TextEditingController costeIngrediente = TextEditingController();
  final TextEditingController costoUnidad = TextEditingController();
  final TextEditingController cantidadIngredienteReceta =
      TextEditingController();
  final ValueNotifier<int?> selectedIngrediente = ValueNotifier<int?>(null);
  String? idSeleccionada;
  String? medidaSeleccionada;
  String searchText = '';
  double coste = 0;
  List<Ingrediente?> listIngrediente = [];
  List<Ingrediente?> listIngredienteReceta = [];
  List<PreIngredienteReceta?> listaRelacion = [];
  bool isNewProduct = false;
  final String idNuevo = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  Widget build(BuildContext context) {
    final RecetaArgument argument =
        ModalRoute.of(context)?.settings.arguments as RecetaArgument;
    Receta receta = Receta(
        idReceta: argument.idReceta != 'vacio' ? argument.idReceta! : idNuevo,
        nombreReceta: argument.nombreProducto!,
        coste: coste);

    final junctionList =
        context.watch<CreacionProductoProvider>().listIngredienteReceta;

    final ingredienteRecetaActual = junctionList.where((element) {
      return element.idReceta.contains(receta.idReceta);
    }).toList();
    for (var i in ingredienteRecetaActual) {
      if (!listIngredienteReceta
          .any((element) => element!.idIngrediente.contains(i.idIngrediente))) {
        listIngredienteReceta.add(Ingrediente(
            idIngrediente: i.idIngrediente,
            nombreIngrediente: i.nombreIngrediente,
            medida: i.medida,
            precio: i.precio,
            unidadesCompradas: i.cantidad));
        listaRelacion.add(i);
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildColumnIngredientes(context, argument.isCerveza, receta),
          const VerticalDivider(),
          buildTableReceta(context, argument, receta, junctionList),
        ],
      ),
    );
  }

  Widget buildColumnIngredientes(
      BuildContext context, bool isCerveza, Receta receta) {
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
                isCerveza ? 'Barriles' : 'Ingredientes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SearchField(
                label: 'Buscar Ingrediente',
                type: TextInputType.name,
                controller: searchField,
                onChanged: (value) {
                  setState(() {
                    searchText = value;
                  });
                },
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: fetchRepository.findAllIngredientes(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      listIngrediente = snapshot.data!;
                      escogerIngrediente(isCerveza);
                      searchFilter();
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
                                      longPressIngrediente(index, ingrediente,
                                          context, isCerveza);
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
                backgroundColor: !isNewIngrediente() ? Colors.blueAccent : null,
                foregroundColor: !isNewIngrediente() ? Colors.white : null,
              ),
              onPressed: () {
                if (isNewIngrediente()) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return dialogCrearIngrediente(context, false, isCerveza);
                    },
                  );
                } else if (double.parse(cantidadIngredienteReceta.text) >
                    listIngrediente[selectedIngrediente.value!]!
                        .unidadesCompradas) {
                } else {
                  addIngredientToReceta(
                      listIngrediente[selectedIngrediente.value!]!, receta);
                }
              },
              icon: Icon(
                  !isNewIngrediente() ? Icons.food_bank_rounded : Icons.add),
              label: Text(
                  '${!isNewIngrediente() ? 'Añadir' : 'Nuevo'} ${isCerveza ? 'Barril' : 'Ingrediente'} '),
            )
          ],
        ),
      ),
    );
  }

  void longPressIngrediente(int index, Ingrediente ingrediente,
      BuildContext context, bool isCerveza) {
    setState(() {
      selectedIngrediente.value = index;
      idSeleccionada = ingrediente.idIngrediente;
      nombreIngrediente.text = ingrediente.nombreIngrediente;
      medidaIngrediente.text = ingrediente.medida.toString();
      cantidadIngrediente.text = ingrediente.unidadesCompradas.toString();
      costeIngrediente.text = ingrediente.precio.toString();
    });

    showDialog(
      context: context,
      builder: (context) {
        return dialogCrearIngrediente(context, true, isCerveza);
      },
    );
  }

  void escogerIngrediente(bool isCerveza) {
    if (isCerveza) {
      listIngrediente = listIngrediente.where((element) {
        return element!.nombreIngrediente
            .toString()
            .toLowerCase()
            .contains('barril'.toLowerCase());
      }).toList();
    } else {
      listIngrediente = listIngrediente.where((element) {
        return !element!.nombreIngrediente
            .toString()
            .toLowerCase()
            .contains('barril'.toLowerCase());
      }).toList();
    }
  }

  void searchFilter() {
    if (searchText.isNotEmpty) {
      listIngrediente = listIngrediente.where((element) {
        return element!.nombreIngrediente
            .toString()
            .toLowerCase()
            .contains(searchText.toString().toLowerCase());
      }).toList();
    }
  }

  bool isNewIngrediente() {
    return selectedIngrediente.value == null &&
        cantidadIngredienteReceta.text.isEmpty;
  }

  void addIngredientToReceta(Ingrediente item, Receta receta) {
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

      coste += itemTablaReceta.first!.precio *
          double.parse(cantidadIngredienteReceta.text);

      listaRelacion[position] = PreIngredienteReceta(
        medida: itemTablaReceta.first!.medida,
        idIngrediente: itemTablaReceta.first!.idIngrediente,
        idIngredienteReceta: listaRelacion[position]!.idIngredienteReceta,
        idReceta: receta.idReceta,
        cantidad: cantidad,
        nombreIngrediente: itemTablaReceta.first!.nombreIngrediente,
        precio: itemTablaReceta.first!.precio,
      );
    } else {
      coste += item.precio * double.parse(cantidadIngredienteReceta.text);
      listaRelacion.add(PreIngredienteReceta(
          medida: item.medida,
          idIngrediente: item.idIngrediente,
          idIngredienteReceta: DateTime.now().millisecondsSinceEpoch.toString(),
          idReceta: receta.idReceta,
          cantidad: double.parse(cantidadIngredienteReceta.text),
          nombreIngrediente: item.nombreIngrediente,
          precio: 0.0));

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

  Dialog dialogCrearIngrediente(
      BuildContext context, bool isEdit, bool isCerveza) {
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
                            label:
                                'Nombre del ${isCerveza ? 'Barril' : 'Ingrediente'}',
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
                                insertIngrediente(isCerveza);
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

  void insertIngrediente(bool isCerveza) {
    fetchRepository.insertIngrediente(Ingrediente(
        idIngrediente: UniqueKey().toString(),
        nombreIngrediente: isCerveza
            ? 'Barril ${nombreIngrediente.text}'
            : nombreIngrediente.text,
        medida: medidaIngrediente.text,
        precio: double.parse(costeIngrediente.text),
        unidadesCompradas: double.parse(cantidadIngrediente.text)));
    Navigator.pop(context);
  }

  Widget buildTableReceta(BuildContext context, RecetaArgument argument,
      Receta receta, List<PreIngredienteReceta> list) {
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
                  receta.nombreReceta,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              Text(receta.coste.abs().toStringAsFixed(3)),
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
                    var itemReceta = listaRelacion[index];
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
                                      setState(() {
                                        if (item.unidadesCompradas > 1) {
                                          cantidadButton(item, index, false,
                                              itemReceta!, receta);
                                        }
                                      });
                                    },
                                    icon: const Icon(
                                        Icons.arrow_downward_outlined)),
                                containerColumn(
                                    item.unidadesCompradas.toString()),
                                IconButton.outlined(
                                    iconSize: 15,
                                    visualDensity: VisualDensity.compact,
                                    onPressed: () {
                                      setState(() {
                                        cantidadButton(item, index, true,
                                            itemReceta!, receta);
                                      });
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
                                        listaRelacion.removeAt(index);
                                        coste -= item.precio *
                                            item.unidadesCompradas;
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
                      onPressed: () {
                        for (var element in listaRelacion) {
                          context
                              .read<CreacionProductoProvider>()
                              .deleteItemIngredienteReceta(element!);
                          context
                              .read<CreacionProductoProvider>()
                              .addIngredienteReceta(element);
                        }
                        context
                            .read<CreacionProductoProvider>()
                            .updateRecetaId(receta.idReceta);
                        Navigator.pop(context);
                      },
                      label: const Text('Agregar Receta'),
                      icon: const Icon(Icons.add_box),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  void cantidadButton(Ingrediente item, int index, bool isSuma,
      PreIngredienteReceta itemReceta, Receta receta) {
    double? cantidad;
    if (isSuma) {
      cantidad = item.unidadesCompradas + 1;
      coste += item.precio;
    } else {
      cantidad = item.unidadesCompradas - 1;
      coste -= item.precio;
    }
    listIngredienteReceta[index] = Ingrediente(
        idIngrediente: item.idIngrediente,
        nombreIngrediente: item.nombreIngrediente,
        medida: item.medida,
        precio: item.precio,
        unidadesCompradas: cantidad);
    listaRelacion[index] = PreIngredienteReceta(
        medida: item.medida,
        idIngrediente: item.idIngrediente,
        idIngredienteReceta: itemReceta.idIngredienteReceta,
        idReceta: receta.idReceta,
        cantidad: cantidad,
        nombreIngrediente: item.nombreIngrediente,
        precio: item.precio);
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
}
