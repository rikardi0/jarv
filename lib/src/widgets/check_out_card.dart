import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jarv/src/utils/models/producto_preordenado.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    super.key,
    required this.size,
    this.productosOrdenados,
    required this.show,
    this.keyPress,
    required this.productoPreOrdenado,
    required this.actualizarCantidad,
  });
  final Size size;
  final List<ProductoPreOrdenado?>? productosOrdenados;
  final bool show;
  final Function? keyPress;

  final ProductoPreOrdenado productoPreOrdenado;
  final Future<void> actualizarCantidad;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.40,
      color: const Color.fromARGB(255, 228, 228, 228),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Card(
          shape: RoundedRectangleBorder(
              side: const BorderSide(color: Color.fromARGB(94, 97, 97, 97)),
              borderRadius: BorderRadius.circular(5)),
          elevation: 7,
          child: Column(children: [
            _buildProductList(),
            FutureBuilder(
                future: actualizarCantidad,
                builder: (context, snapshot) {
                  return Container(
                    color: Colors.red,
                    height: size.height * 0.1,
                    width: size.width * 0.35,
                    child: ListTile(
                      title: Text(productoPreOrdenado.cantidad),
                    ),
                  );
                }),
            _buildTotal(),
            _buildKeyboard(),
          ]),
        ),
      ),
    );
  }

  // ignore: unused_element
  Widget _buildHeader() {
    return SizedBox(
      width: size.width * 0.35,
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Name",
            ),
            Text(
              "Qty",
              textAlign: TextAlign.center,
            ),
            Text("Each"),
            Text("Total"),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.amber,
        width: size.width * 0.35,
        height: size.height * 0.1,
        child: ListView.builder(
          itemCount: productosOrdenados?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            final ProductoPreOrdenado? producto = productosOrdenados![index];
            return _buildProductItem(producto!);
          },
        ),
      ),
    );
  }

  Widget _buildProductItem(ProductoPreOrdenado producto) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ListTile(
          title: Text(producto.nombreProducto),
          subtitle: Text('${producto.precio} x ${producto.cantidad}'),
        ),
        const Expanded(child: Text("12.00"))
      ],
    );
  }

  Widget _buildKeyboard() {
    return Visibility(
      visible: show,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: VirtualKeyboard(
                  type: VirtualKeyboardType.Numeric,
                  height: size.height * 0.2,
                  onKeyPress: keyPress,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () {},
              label: const Text("Anadir"),
              icon: const Icon(Icons.add),
            )
          ],
        ),
      ),
    );
  }

  Padding _buildTotal() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text("TOTAL:"),
          SizedBox(
            width: size.width * 0.05,
          ),
          const Text("12.98"),
        ],
      ),
    );
  }
}
