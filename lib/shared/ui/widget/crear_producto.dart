import 'package:flutter/material.dart';
import 'package:jarv/app/feature/login/ui/view/widget/image_picker.dart';
import 'package:jarv/shared/data/model/entity.dart';
import 'package:jarv/shared/ui/widget/custom_text_field.dart';

class CrearProducto extends StatefulWidget {
  const CrearProducto({
    super.key,
  });

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
  final TextEditingController medida = TextEditingController();
  final TextEditingController ganancia = TextEditingController();
  final TextEditingController idSubfamiliaProducto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (listFamilia.length == 1) {
      selectedFamilia.value = 0;
    }
    if (listSubFamilia.length == 1) {
      selectedSubFamilia.value = 0;
    }

    return Container(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            columnFamilia(context),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                listFamilia.isEmpty ? const SizedBox() : rowSubFamilia(context),
                listFamilia.isEmpty ? const SizedBox() : gridProducto(context),
              ],
            ),
          ],
        ));
  }

  Widget columnFamilia(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      height: MediaQuery.of(context).size.height * 0.7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Familia',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                listFamilia.isEmpty
                    ? const SizedBox()
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
                addCard(() {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return dialogFamilia(context, false);
                    },
                  );
                }),
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
                CustomTextField(
                    label: 'Nombre Familia',
                    value: nombreFamilia.text,
                    controller: nombreFamilia,
                    keyboard: TextInputType.text),
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
                            if (isEdit) {
                              final keyProducto =
                                  listFamilia[selectedFamilia.value].idFamilia;
                              listFamilia[selectedFamilia.value] =
                                  Familia(keyProducto, nombreFamilia.text, '0');
                            } else {
                              listFamilia.add(Familia(UniqueKey().toString(),
                                  nombreFamilia.text, '0'));
                            }

                            nombreFamilia.clear();
                            Navigator.pop(context);
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
    listSubFamilia.removeWhere((element) => element.idFamilia
        .contains(listFamilia[selectedFamilia.value].idFamilia));
    listFamilia.removeAt(selectedFamilia.value);
    Navigator.pop(context);
  }

  Widget rowSubFamilia(BuildContext context) {
    final listaSubFamiliaSeleccionada = listSubFamilia.where((element) {
      return element.idFamilia.toString().toLowerCase().contains(
          listFamilia[selectedFamilia.value]
              .idFamilia
              .toString()
              .toLowerCase());
    });
    final width = MediaQuery.of(context).size.width * 0.775;
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'Sub-Familia ${listFamilia[selectedFamilia.value].nombreFamilia}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Row(
            children: [
              listSubFamilia.isEmpty
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
              addCard(() {
                showDialog(
                  context: context,
                  builder: (context) {
                    return dialogSubFamilia(context, false);
                  },
                );
              }),
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
                              setState(() {
                                if (selectedSubFamilia.value != null) {
                                  listProducto.removeWhere((element) => element
                                      .idSubfamilia
                                      .contains(listSubFamilia[
                                              selectedSubFamilia.value]
                                          .idSubfamilia));
                                  listSubFamilia
                                      .removeAt(selectedSubFamilia.value);
                                }

                                Navigator.pop(context);
                              });
                            },
                            icon: const Icon(Icons.delete),
                          )
                        : const SizedBox.shrink()
                  ],
                ),
                CustomTextField(
                    label: 'Nombre Sub-Familia',
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
                          setState(() {
                            if (isEdit) {
                              editSubFamilia();
                            } else {
                              loadSubFamilia();
                            }

                            Navigator.pop(context);
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
    final height = MediaQuery.of(context).size.height * 0.55;
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
                      padding: const EdgeInsets.only(bottom: 16.0),
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
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5 / 3,
      child: Card(
          elevation: 5,
          shape: const RoundedRectangleBorder(),
          child: ListTile(
            onTap: () {
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
                      fontSize:
                          Theme.of(context).textTheme.headlineSmall!.fontSize),
                ),
                const Icon(
                  Icons.add,
                  size: 30,
                ),
              ],
            ),
          )),
    );
  }

  Dialog dialogProducto(BuildContext context, isEdit) {
    if (precio.text.isNotEmpty && coste.text.isNotEmpty) {
      ganancia.text =
          (double.parse(precio.text) - double.parse(coste.text)).toString();
    }
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.25,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${isEdit ? 'Editar' : 'Agregar'} Articulo',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: CustomTextField(
                                    label: 'Nombre Producto',
                                    value: productoNombre.text,
                                    controller: productoNombre,
                                    keyboard: TextInputType.text),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
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
                                        child: TextFormField(
                                      readOnly: true,
                                      controller: ganancia,
                                      decoration: const InputDecoration(
                                        label: Text('Ganancia'),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0))),
                                      ),
                                    )),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
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
                                      child: CustomTextField(
                                          label: 'Medida',
                                          value: medida.text,
                                          controller: medida,
                                          keyboard: TextInputType.text),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              isEdit
                                  ? FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          foregroundColor: Theme.of(context)
                                              .colorScheme
                                              .onSecondaryContainer),
                                      onPressed: () {
                                        setState(() {
                                          listProducto
                                              .removeAt(selectedProducto.value);
                                          Navigator.pop(context);
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                      label: const Text('Eliminar'))
                                  : const SizedBox.shrink(),
                              const ImagePicker(
                                ratio: 0.25,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        foregroundColor: Theme.of(context)
                                            .colorScheme
                                            .onTertiaryContainer,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer),
                                    onPressed: () {},
                                    icon: const Icon(Icons.receipt_long),
                                    label: const Text('Recetas')),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                                  editProducto();
                                } else {
                                  loadProducto();
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
  }

  void editProducto() {
    final keyProducto = listProducto[selectedProducto.value].productoId;
    final keySubFamilia = listProducto[selectedProducto.value].idSubfamilia;
    listProducto[selectedProducto.value] = Producto(
        keyProducto,
        productoNombre.text,
        double.parse(precio.text),
        double.parse(coste.text),
        double.parse(iva.text),
        keySubFamilia,
        int.parse(medida.text));
  }

  void onTapProducto(
      List<dynamic> listProductoItem, int index, BuildContext context) {
    final globalPosition = listProducto.indexOf(listProductoItem[index]);
    selectedProducto.value = globalPosition;
    productoNombre.text = listProducto[selectedProducto.value].producto;

    showDialog(
      context: context,
      builder: (context) {
        return dialogProducto(context, true);
      },
    );
    setState(() {});
  }

  void loadProducto() {
    listProducto.add(Producto(
        DateTime.now().microsecondsSinceEpoch,
        productoNombre.text,
        double.parse(precio.text),
        double.parse(coste.text),
        double.parse(iva.text),
        listSubFamilia[selectedSubFamilia.value].idSubfamilia,
        int.parse(medida.text)));
  }

  Widget addCard(action) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.15,
      height: 70,
      child: Card(
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

  SizedBox cardElement(int index, BuildContext context, String content,
      notifier, tileNotifier, longPressAction, onTap) {
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
