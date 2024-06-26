import 'package:flutter/material.dart';
import 'package:jarv/app/feature/creacion_producto/ui/provider/creacion_producto_provider.dart';
import 'package:jarv/app/feature/creacion_producto/ui/view/recetas_view.dart';
import 'package:jarv/app/feature/login/data/model/recetas_argument.dart';
import 'package:jarv/app/feature/login/ui/widget/image_picker.dart';
import 'package:jarv/shared/data/model/entity.dart';
import 'package:jarv/shared/ui/utils/validators.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';
import 'package:jarv/shared/ui/widget/medida_selector.dart';
import 'package:provider/provider.dart';

class CrearProducto extends StatefulWidget {
  const CrearProducto({
    super.key,
    this.continueAction,
    this.cancelAction,
  });

  final dynamic continueAction;
  final dynamic cancelAction;

  @override
  State<CrearProducto> createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  List<Familia> listFamilia = [];
  List<SubFamilia> listSubFamilia = [];
  List<Producto> listProducto = [];

  ValueNotifier selectedFamilia = ValueNotifier<int?>(null);
  ValueNotifier selectedSubFamilia = ValueNotifier<int?>(null);
  ValueNotifier selectedTileSubFamilia = ValueNotifier<int?>(null);
  ValueNotifier selectedProducto = ValueNotifier<int?>(null);
  ValueNotifier selectedTileProducto = ValueNotifier<int?>(null);
  final TextEditingController nombreFamilia = TextEditingController();
  final TextEditingController nombreSubFamilia = TextEditingController();
  final TextEditingController idFamiliaSubFamilia = TextEditingController();

  final TextEditingController productoNombre = TextEditingController();
  final TextEditingController precio = TextEditingController();
  final TextEditingController coste = TextEditingController();
  final TextEditingController iva = TextEditingController();
  final TextEditingController cantidad = TextEditingController();
  final TextEditingController ganancia = TextEditingController();
  final TextEditingController idSubfamiliaProducto = TextEditingController();

  String? medida;
  GlobalKey<FormState> familiaFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> subFamiliaFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final junctionList =
        context.watch<CreacionProductoProvider>().listIngredienteReceta;
    if (listFamilia.length == 1) {
      selectedFamilia.value = 0;
    }

    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              columnFamilia(context),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  listFamilia.isEmpty
                      ? const SizedBox()
                      : rowSubFamilia(context),
                  listFamilia.isEmpty
                      ? const SizedBox.shrink()
                      : gridProducto(context),
                ],
              ),
            ],
          ),
        ),
        buildActionRow()
      ],
    );
  }

  Widget buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledButton.tonal(
          onPressed: () {
            if (listFamilia.isNotEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(
                      'Atencion!',
                      textAlign: TextAlign.left,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    content: const Text('Los cambios seran eliminados'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar')),
                      FilledButton(
                          onPressed: () {
                            widget.cancelAction();
                            Navigator.pop(context);
                          },
                          child: const Text('Aceptar'))
                    ],
                  );
                },
              );
            } else {
              widget.cancelAction();
            }
          },
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            context
                .read<CreacionProductoProvider>()
                .setListFamilia(listFamilia);
            context
                .read<CreacionProductoProvider>()
                .setListSubFamilia(listSubFamilia);
            context
                .read<CreacionProductoProvider>()
                .setListProducto(listProducto);
            widget.continueAction();
          },
          child: const Text('Continuar'),
        ),
      ],
    );
  }

  Widget columnFamilia(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.height * 0.725,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              selectedFamilia.value == null
                  ? ''
                  : listFamilia[selectedFamilia.value].nombreFamilia,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                listFamilia.isEmpty
                    ? const SizedBox.shrink()
                    : Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: listFamilia.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: cardElement(
                                  index,
                                  context,
                                  listFamilia[index].nombreFamilia,
                                  selectedFamilia,
                                  selectedFamilia,
                                  () => longPressFamilia(index, context),
                                  () => onTapFamilia(index)),
                            );
                          },
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: addCard(() {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return dialogFamilia(context, false);
                      },
                    );
                  }),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Dialog dialogFamilia(BuildContext context, bool isEdit) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${isEdit ? 'Editar' : 'Agregar'} Familia ',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    isEdit
                        ? IconButton(
                            onPressed: () {
                              setState(() {
                                deleteFamilia(context);
                              });
                            },
                            icon: const Icon(Icons.delete))
                        : const SizedBox.shrink()
                  ],
                ),
                Form(
                  key: familiaFormKey,
                  child: CustomTextField(
                      label: 'Nombre Familia',
                      value: nombreFamilia.text,
                      controller: nombreFamilia,
                      validateAction: (String value) {
                        return emptyValidator(value);
                      },
                      keyboard: TextInputType.text),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          nombreFamilia.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    FilledButton(
                        onPressed: () {
                          setState(() {
                            if (familiaFormKey.currentState!.validate()) {
                              if (isEdit) {
                                final keyProducto =
                                    listFamilia[selectedFamilia.value]
                                        .idFamilia;
                                listFamilia[selectedFamilia.value] = Familia(
                                    keyProducto, nombreFamilia.text, '0');
                              } else {
                                listFamilia.add(Familia(UniqueKey().toString(),
                                    nombreFamilia.text, '0'));
                              }

                              nombreFamilia.clear();
                              Navigator.pop(context);
                            }
                          });
                        },
                        child: const Text('Aceptar'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onTapFamilia(int index) {
    setState(() {
      selectedFamilia.value = index;
      selectedSubFamilia.value = null;
      selectedTileSubFamilia.value = null;
    });
  }

  void longPressFamilia(int index, BuildContext context) {
    selectedFamilia.value = index;
    nombreFamilia.text = listFamilia[selectedFamilia.value].nombreFamilia;

    showDialog(
        context: context,
        builder: (context) {
          return dialogFamilia(context, true);
        });
    setState(() {});
  }

  void deleteFamilia(BuildContext context) {
    final List<SubFamilia> subFamilia = listSubFamilia
        .where((element) => element.idFamilia
            .contains(listFamilia[selectedFamilia.value].idFamilia))
        .toList();
    for (var subFamilia in subFamilia) {
      listProducto.removeWhere(
          (element) => element.idSubfamilia.contains(subFamilia.idSubfamilia));
    }
    listSubFamilia.removeWhere((element) => element.idFamilia
        .contains(listFamilia[selectedFamilia.value].idFamilia));
    listFamilia.removeAt(selectedFamilia.value);
    selectedSubFamilia.value = null;
    selectedFamilia.value = null;
    nombreFamilia.clear();
    Navigator.pop(context);
  }

  Widget rowSubFamilia(BuildContext context) {
    Iterable listaSubFamiliaSeleccionada = [];
    if (selectedFamilia.value != null) {
      listaSubFamiliaSeleccionada = listSubFamilia.where((element) {
        return element.idFamilia.toString().toLowerCase().contains(
            listFamilia[selectedFamilia.value]
                .idFamilia
                .toString()
                .toLowerCase());
      });
    }

    final width = MediaQuery.of(context).size.width * 0.775;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
            child: Text(
              selectedSubFamilia.value == null
                  ? ''
                  : listSubFamilia[selectedSubFamilia.value].nombreSub,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              listaSubFamiliaSeleccionada.isEmpty
                  ? const SizedBox()
                  : Flexible(
                      child: SizedBox(
                        height: 70,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: listaSubFamiliaSeleccionada.length,
                          itemBuilder: (context, index) {
                            final nameSubFamilia = [];
                            final subFamilia = [];
                            for (var element in listaSubFamiliaSeleccionada) {
                              nameSubFamilia.add(element.nombreSub);
                              subFamilia.add(element);
                            }
                            return SizedBox(
                                width: width / 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: cardElement(
                                      index,
                                      context,
                                      nameSubFamilia[index],
                                      selectedSubFamilia,
                                      selectedTileSubFamilia,
                                      () => onLongPressSubFamilia(
                                          subFamilia, index, context),
                                      () => onTapSubFamilia(subFamilia, index)),
                                ));
                          },
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: addCard(() {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return dialogSubFamilia(context, false);
                    },
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Dialog dialogSubFamilia(BuildContext context, bool isEdit) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.35,
          child: Form(
            key: subFamiliaFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Agregar Sub-Familia',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    isEdit
                        ? IconButton(
                            onPressed: () {
                              deleteSubFamilia(context);
                            },
                            icon: const Icon(Icons.delete),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
                CustomTextField(
                    label: 'Nombre Sub-Familia',
                    validateAction: (String value) {
                      return emptyValidator(value);
                    },
                    value: nombreSubFamilia.text,
                    controller: nombreSubFamilia,
                    keyboard: TextInputType.text),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          nombreSubFamilia.clear();
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar')),
                    FilledButton(
                        onPressed: () {
                          if (subFamiliaFormKey.currentState!.validate()) {
                            setState(() {
                              if (isEdit) {
                                editSubFamilia();
                              } else {
                                loadSubFamilia();
                              }
                              Navigator.pop(context);
                            });
                          }
                        },
                        child: const Text('Aceptar'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteSubFamilia(BuildContext context) {
    setState(() {
      listProducto.removeWhere((element) => element.idSubfamilia
          .contains(listSubFamilia[selectedSubFamilia.value].idSubfamilia));
      listSubFamilia.removeAt(selectedSubFamilia.value);
      selectedSubFamilia.value = null;
      selectedTileSubFamilia.value = null;
      nombreSubFamilia.clear();
      Navigator.pop(context);
    });
  }

  void onLongPressSubFamilia(
      List<dynamic> subFamilia, int index, BuildContext context) {
    final globalPosition = listSubFamilia.indexOf(subFamilia[index]);
    selectedSubFamilia.value = globalPosition;
    nombreSubFamilia.text = listSubFamilia[selectedSubFamilia.value].nombreSub;
    showDialog(
        context: context,
        builder: (context) {
          return dialogSubFamilia(context, true);
        });
  }

  void onTapSubFamilia(List<dynamic> subFamilia, int index) {
    final globalPosition = listSubFamilia.indexOf(subFamilia[index]);
    setState(() {
      selectedTileSubFamilia.value = index;
      selectedSubFamilia.value = globalPosition;
      selectedTileProducto.value = null;
      selectedProducto.value = null;
    });
  }

  void editSubFamilia() {
    final keySubFamilia = listSubFamilia[selectedSubFamilia.value].idSubfamilia;
    final keyFamilia = listSubFamilia[selectedSubFamilia.value].idFamilia;
    listSubFamilia[selectedSubFamilia.value] =
        SubFamilia(keySubFamilia, nombreSubFamilia.text, keyFamilia);
    nombreSubFamilia.clear();
  }

  void loadSubFamilia() {
    listSubFamilia.add(SubFamilia(UniqueKey().toString(), nombreSubFamilia.text,
        listFamilia[selectedFamilia.value].idFamilia));
    nombreSubFamilia.clear();
  }

  Widget gridProducto(BuildContext context) {
    final listaProductoSeleccionado = listProducto.where((element) {
      if (selectedSubFamilia.value != null) {
        return element.idSubfamilia
            .toString()
            .toLowerCase()
            .contains(listSubFamilia[selectedSubFamilia.value].idSubfamilia);
      } else {
        return false;
      }
    });

    final width = MediaQuery.of(context).size.width * 0.5;
    final height = MediaQuery.of(context).size.height * 0.6;
    return Expanded(
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            listProducto.isEmpty
                ? const SizedBox.shrink()
                : Flexible(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: GridView.builder(
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          mainAxisExtent: height / 3,
                        ),
                        itemCount: listaProductoSeleccionado.length,
                        itemBuilder: (context, index) {
                          final itemNombre = [];
                          final itemPrecio = [];
                          final itemCoste = [];
                          final itemIVA = [];
                          final itemMedida = [];
                          final listProductoItem = [];
                          for (var element in listaProductoSeleccionado) {
                            listProductoItem.add(element);
                            itemNombre.add(element.producto);
                            itemPrecio.add(element.precio);
                            itemCoste.add(element.coste);
                            itemIVA.add(element.iva);
                            itemMedida.add(element.medida);
                          }

                          return Card(
                              elevation: 5,
                              child: ListTile(
                                onTap: () {
                                  onTapProducto(
                                      listProductoItem, index, context);
                                },
                                title: Text(itemNombre[index]),
                                subtitle: Text(itemPrecio[index].toString()),
                              ));
                        },
                      ),
                    ),
                  ),
            selectedSubFamilia.value == null
                ? const SizedBox.shrink()
                : addCardProducto(context)
          ],
        ),
      ),
    );
  }

  Widget addCardProducto(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5 / 3,
        child: Card(
            elevation: 5,
            shape: const RoundedRectangleBorder(),
            child: ListTile(
              onTap: () {
                context.read<CreacionProductoProvider>().clearRecetaId();
                selectedProducto.value = null;
                setState(() {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return dialogProducto(context, false);
                    },
                  );
                });
              },
              title: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Producto',
                    style: TextStyle(
                        fontSize: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .fontSize),
                  ),
                  const Icon(
                    Icons.add,
                    size: 30,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget dialogProducto(BuildContext context, isEdit) {
    if (precio.text.isNotEmpty && coste.text.isNotEmpty) {
      ganancia.text =
          (double.parse(precio.text) - double.parse(coste.text)).toString();
    }
    return StatefulBuilder(builder: (context, state) {
      final String? idReceta =
          context.watch<CreacionProductoProvider>().recetaId;
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 64.0, vertical: 8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                  initialValue:
                                      listFamilia[selectedFamilia.value]
                                          .nombreFamilia,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    label: Text('Familia'),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextFormField(
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer),
                                  initialValue:
                                      listSubFamilia[selectedSubFamilia.value]
                                          .nombreSub,
                                  readOnly: true,
                                  decoration: const InputDecoration(
                                    label: Text('Sub-Familia'),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${isEdit ? 'Editar' : 'Agregar'} Producto',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                      Visibility(
                                        visible: isEdit,
                                        child: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                listProducto.removeAt(
                                                    selectedProducto.value);
                                                Navigator.pop(context);
                                              });
                                            },
                                            icon: const Icon(Icons.delete)),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: CustomTextField(
                                        label: 'Nombre Producto',
                                        value: productoNombre.text,
                                        controller: productoNombre,
                                        keyboard: TextInputType.text),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextField(
                                            label: 'Precio',
                                            value: precio.text,
                                            controller: precio,
                                            keyboard: TextInputType.number),
                                      ),
                                      Expanded(
                                        child: CustomTextField(
                                            label: 'Coste',
                                            value: coste.text,
                                            controller: coste,
                                            keyboard: TextInputType.number),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: ganancia,
                                          decoration: const InputDecoration(
                                            label: Text('Ganancia'),
                                            border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomTextField(
                                              label: 'IVA',
                                              value: iva.text,
                                              controller: iva,
                                              keyboard: TextInputType.number),
                                        ),
                                        Expanded(
                                            child: MedidaSelector(
                                          value: listProducto[
                                                  selectedProducto.value]
                                              .medida,
                                          onChanged: (value) {
                                            setState(() {
                                              medida = value;
                                            });
                                          },
                                        )),
                                        Expanded(
                                          child: CustomTextField(
                                              label: 'Cantidad',
                                              value: cantidad.text,
                                              controller: cantidad,
                                              keyboard: TextInputType.text),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.175,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const ImagePicker(
                                    ratio: 0.3,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onTertiary,
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .tertiary,
                                        ),
                                        onPressed: productoNombre.text.isEmpty
                                            ? null
                                            : () {
                                                final int? index =
                                                    selectedProducto.value;
                                                Navigator.pushNamed(context,
                                                    RecetasView.routeName,
                                                    arguments: RecetaArgument(
                                                      idReceta: index != null
                                                          ? listProducto[index]
                                                              .idReceta
                                                          : 'vacio',
                                                      nombreProducto:
                                                          productoNombre.text,
                                                    ));
                                              },
                                        icon: const Icon(Icons.receipt_long),
                                        label: const Text('Escandallo')),
                                  ),
                                ],
                              ),
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
                                    editProducto(idReceta!);
                                  } else {
                                    loadProducto(idReceta!);
                                  }

                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('Aceptar')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  void editProducto(String id) {
    final keyProducto = listProducto[selectedProducto.value].productoId;
    final keySubFamilia = listProducto[selectedProducto.value].idSubfamilia;

    listProducto[selectedProducto.value] = Producto(
        productoId: keyProducto,
        producto: productoNombre.text,
        precio: double.parse(precio.text),
        coste: double.parse(coste.text),
        iva: double.parse(iva.text),
        idSubfamilia: keySubFamilia,
        medida: medida!,
        idReceta: id,
        cantidad: int.parse(cantidad.text),
        imageFile: '');
  }

  void onTapProducto(
      List<dynamic> listProductoItem, int index, BuildContext context) {
    final globalPosition = listProducto.indexOf(listProductoItem[index]);
    selectedProducto.value = globalPosition;
    productoNombre.text = listProducto[selectedProducto.value].producto;
    final producto = listProducto[selectedProducto.value];
    if (producto.idReceta == 'vacio') {
      context.read<CreacionProductoProvider>().clearRecetaId();
    } else {
      context
          .read<CreacionProductoProvider>()
          .updateRecetaId(producto.idReceta);
    }

    showDialog(
      context: context,
      builder: (context) {
        return dialogProducto(context, true);
      },
    );
    setState(() {});
  }

  void loadProducto(String id) {
    listProducto.add(Producto(
        productoId: DateTime.now().microsecondsSinceEpoch,
        producto: productoNombre.text,
        precio: double.parse(precio.text),
        coste: double.parse(coste.text),
        iva: double.parse(iva.text),
        idSubfamilia: listSubFamilia[selectedSubFamilia.value].idSubfamilia,
        medida: medida!,
        idReceta: id,
        cantidad: int.parse(cantidad.text),
        imageFile: ''));
  }

  Widget addCard(action) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      height: 70,
      child: Card(
        color: Theme.of(context).colorScheme.primaryContainer,
        elevation: 5,
        shape: const RoundedRectangleBorder(),
        child: ListTile(
          onTap: action,
          title: const Icon(
            Icons.add,
          ),
        ),
      ),
    );
  }

  Widget cardElement(int index, BuildContext context, String content, notifier,
      tileNotifier, longPressAction, onTap) {
    return SizedBox(
      height: 70,
      child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                  color: notifier.value == index
                      ? Colors.white
                      : Colors.transparent)),
          color: tileNotifier.value == index
              ? Theme.of(context).colorScheme.primary
              : null,
          child: ListTile(
              onLongPress: () {
                longPressAction();
              },
              onTap: () {
                onTap();
              },
              selectedColor: Theme.of(context).colorScheme.onPrimary,
              selected: tileNotifier.value == index ? true : false,
              title: Text(content))),
    );
  }
}
