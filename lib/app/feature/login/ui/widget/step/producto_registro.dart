import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:jarv/app/feature/creacion_producto/ui/widget/crear_producto.dart';

class ProductoRegistro extends StatefulWidget {
  const ProductoRegistro({
    super.key,
    this.continueAction,
  });

  static int positionStepper = 4;
  final dynamic continueAction;

  @override
  State<ProductoRegistro> createState() => _ProductoRegistroState();
}

class _ProductoRegistroState extends State<ProductoRegistro> {
  ValueNotifier<int?> selectMethod = ValueNotifier<int?>(null);
  bool methodSelected = false;
  FilePickerResult? result;
  String? fileName;
  List<List<dynamic>> file = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !methodSelected
            ? buildMethodSelection(context, theme)
            : selectMethod.value == 2
                ? buildManualMethod(context)
                : selectMethod.value == 1
                    ? buildLoadMethod()
                    : buildPredeterminado(),
      ],
    );
  }

  Widget buildPredeterminado() {
    return Container(
        color: Colors.blue,
        height: MediaQuery.of(context).size.height * 0.75,
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Predeterminado'),
          ],
        ));
  }

  Widget buildLoadMethod() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cargar Archivos',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Este método permite cargar de manera eficiente y automatizada la información de productos a partir de un archivo CSV',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ),
            ],
          ),
          buildCardContainer(),
          file.isNotEmpty ? cardFileName() : const SizedBox(),
          buildActionRow(),
        ],
      ),
    );
  }

  Widget buildActionRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FilledButton.tonal(
          onPressed: () {
            setState(() {
              methodSelected = false;
            });
          },
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () {
            widget.continueAction();
          },
          child: const Text('Continuar'),
        ),
      ],
    );
  }

  Widget buildCardContainer() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: GestureDetector(
          onTap: () async {
            getFile();
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(
                      color: file.isNotEmpty
                          ? Colors.transparent
                          : Theme.of(context).colorScheme.secondary)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: file.isEmpty ? const FileSelector() : buildListView(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      itemCount: file.length,
      itemBuilder: (context, index) {
        final columnProducto = file[index][0];
        final columnPrecio = file[index][1];
        final columnFamilia = file[index][2];
        final columnSubFamilia = file[index][3];
        final columnCoste = file[index][4];
        final columnIva = file[index][5];
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                containerColumn(columnProducto),
                containerColumn(columnPrecio.toString()),
                containerColumn(columnCoste.toString()),
                containerColumn(columnIva.toString()),
                containerColumn(columnFamilia),
                containerColumn(columnSubFamilia),
              ],
            ),
            const Divider()
          ],
        );
      },
    );
  }

  Widget containerColumn(item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
          width: 100,
          child: Text(
            item,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          )),
    );
  }

  Widget cardFileName() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(fileName!),
              trailing: GestureDetector(
                onTap: () {
                  setState(() {
                    file.clear();
                    fileName = '';
                  });
                },
                child: const Icon(Icons.clear),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildManualMethod(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: CrearProducto(
        continueAction: () {
          widget.continueAction();
        },
        cancelAction: () {
          setState(() {
            methodSelected = false;
          });
        },
      ),
    );
  }

  Padding buildMethodSelection(BuildContext context, ColorScheme theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Tu registro está casi listo!',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      'Ahora solo tienes que seleccioner los productos. Elige la manera mas comoda de realizar este proceso.',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                cardButton(Icons.settings_suggest_outlined, 'Predeterminado',
                    'Este metodo blbalbalbalbal ', theme.primary, 0, context),
                cardButton(Icons.upload_file_outlined, 'Importacion',
                    'Este metodo blbalbalbalbal ', theme.secondary, 1, context),
                cardButton(Icons.account_tree_outlined, 'Manual',
                    'Este metodo blbalbalbalbal ', theme.tertiary, 2, context),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                'Para continuar con el proceso, haz clic en tu metodo favorito',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            )
          ],
        ),
      ),
    );
  }

  Card cardButton(
    IconData icon,
    label,
    description,
    colorIcon,
    int index,
    context,
  ) {
    return Card(
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(26.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 140,
              color: colorIcon,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.1,
                child: Text(
                  description,
                  style: TextStyle(
                      color: colorIcon,
                      fontSize:
                          Theme.of(context).textTheme.bodyLarge!.fontSize),
                  textAlign: TextAlign.center,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    methodSelected = true;
                    selectMethod.value = index;
                  });
                },
                style: ElevatedButton.styleFrom(foregroundColor: colorIcon),
                child: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getFile() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );
    if (result != null) {
      if (result!.files.single.extension == 'csv') {
        final path = result!.files.single.path;
        final input = File(path!).openRead();
        final fields = await input
            .transform(utf8.decoder)
            .transform(const CsvToListConverter())
            .toList();

        file = fields;
        fileName = result!.files.single.name;
        setState(() {});
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const Dialog(
              child: Text('Asco'),
            );
          },
        );
      }
    }
  }
}

class FileSelector extends StatelessWidget {
  const FileSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.upload_file_outlined,
          size: 100,
          color: Theme.of(context).colorScheme.secondary,
        ),
        Text(
          'Seleccione el Archivo',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.headlineSmall!.fontSize,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        Text(
          'Escoja el archivo csv para cargar sus productos',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
            color: Theme.of(context).colorScheme.secondary,
          ),
        )
      ],
    );
  }
}
