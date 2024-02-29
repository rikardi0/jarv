import 'package:flutter/material.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';

class CheckOut extends StatelessWidget {
  const CheckOut(
      {super.key,
      required this.mostrarIdentificador,
      required this.productosAgregados,
      required this.totalVenta,
      required this.productoPreOrdenado,
      required this.actualizarCantidad,
      this.onTextIdentificadorTap,
      this.onBackIdentificador,
      this.onAceptarIdentificador,
      this.clearButton,
      this.onTapNum,
      this.addAction,
      required this.cantidad,
      this.backspace});

  final bool mostrarIdentificador;
  final List<ProductoPreOrdenado?> productosAgregados;
  final double totalVenta;
  final ProductoPreOrdenado productoPreOrdenado;
  final List<String> cantidad;
  final Future<void> actualizarCantidad;
  final dynamic onTextIdentificadorTap;
  final dynamic onBackIdentificador;
  final dynamic onAceptarIdentificador;
  final dynamic clearButton;
  final dynamic onTapNum;
  final dynamic addAction;
  final dynamic backspace;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(color: Color.fromARGB(59, 7, 7, 7)),
          borderRadius: BorderRadius.circular(20)),
      elevation: 7,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _listaProductoOrdenado(),
          _totalVenta(),
          _elementoPreOrdenado(),
          _teclado(context)
        ],
      ),
    );
  }

  Expanded _listaProductoOrdenado() {
    return Expanded(
      child: mostrarIdentificador
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 2.0),
                  child: TextFormField(
                    onFieldSubmitted: (value) {
                      onTextIdentificadorTap(value);
                    },
                    decoration: const InputDecoration(
                        labelText: 'Identificador de Venta'),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          onBackIdentificador();
                        },
                        child: const Text('Volver')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurpleAccent,
                            foregroundColor: Colors.white),
                        onPressed: () {
                          onAceptarIdentificador();
                        },
                        child: const Text('Aceptar'))
                  ],
                )
              ],
            )
          : ListView.builder(
              itemCount: productosAgregados.length,
              itemBuilder: (BuildContext context, int index) {
                final ProductoPreOrdenado? producto = productosAgregados[index];
                final double total =
                    double.parse(producto!.cantidad) * producto.precio;

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ListTile(
                            visualDensity: VisualDensity.compact,
                            title: Text(producto.nombreProducto),
                            subtitle: Text(
                                '${producto.cantidad} x ${producto.precio}€'),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(total.toString()),
                        ),
                      ],
                    ),
                    Divider(
                      height: MediaQuery.of(context).size.height * 0.1,
                    )
                  ],
                );
              },
            ),
    );
  }

  Visibility _totalVenta() {
    return Visibility(
      visible:
          productosAgregados.isEmpty || mostrarIdentificador ? false : true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
                icon: const Icon(Icons.clear_all_rounded),
                onPressed: () {
                  clearButton();
                },
                label: const Text('Limpiar Lista')),
            Text(totalVenta != 0.0 ? '€ ${totalVenta.toString()}' : '')
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> _elementoPreOrdenado() {
    return FutureBuilder(
        future: actualizarCantidad,
        builder: (context, snapshot) {
          return Container(
              color: const Color.fromARGB(50, 54, 54, 54),
              height: MediaQuery.of(context).size.height * 0.08,
              width: MediaQuery.of(context).size.width * 0.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(productoPreOrdenado.nombreProducto),
                  Text(productoPreOrdenado.cantidad),
                  Text(productoPreOrdenado.precio != 0
                      ? '€ ${productoPreOrdenado.precio.toString()}'
                      : ''),
                ],
              ));
        });
  }

  Column _teclado(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Center(
              child: GridView(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 0,
                    mainAxisExtent: MediaQuery.of(context).size.height * 0.075),
                clipBehavior: Clip.antiAlias,
                children: [
                  _itemNumeroTeclado('1'),
                  _itemNumeroTeclado('2'),
                  _itemNumeroTeclado('3'),
                  GestureDetector(
                      onTap: () => addAction(cantidad),
                      child: _itemActionTeclado(Icons.add_box_outlined)),
                  _itemNumeroTeclado('4'),
                  _itemNumeroTeclado('5'),
                  _itemNumeroTeclado('6'),
                  containerTeclado(const Text('')),
                  _itemNumeroTeclado('7'),
                  _itemNumeroTeclado('8'),
                  _itemNumeroTeclado('9'),
                  GestureDetector(
                      onTap: () => backspace(cantidad),
                      child: _itemActionTeclado(Icons.backspace_outlined)),
                  containerTeclado(const Text('')),
                  _itemNumeroTeclado('0'),
                  containerTeclado(const Text('')),
                  containerTeclado(const Text('')),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _itemNumeroTeclado(String label) {
    return GestureDetector(
      onTap: () => onTapNum(label),
      child: containerTeclado(Text(label)),
    );
  }

  Widget _itemActionTeclado(IconData icon) {
    return containerTeclado(Icon(icon));
  }

  Container containerTeclado(Widget element) {
    return Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(115, 235, 235, 235),
            border: Border.all(
                color: const Color.fromARGB(59, 7, 7, 7), width: 0.5)),
        child: Center(child: element));
  }
}
