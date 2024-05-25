import 'package:flutter/material.dart';

import '../../data/model/entity.dart';

class GridProducto extends StatelessWidget {
  const GridProducto({
    super.key,
    required this.selectedProductoIndex,
    required this.itemProducto,
    required this.joinedCantidad,
    required this.borderColor,
    required this.onProductTap,
  });

  final ValueNotifier<int?> selectedProductoIndex;
  final List<Producto?>? itemProducto;
  final String joinedCantidad;
  final Color borderColor;
  final dynamic onProductTap;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final SliverGridDelegateWithFixedCrossAxisCount grid =
        SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 3,
      mainAxisSpacing: 0,
      crossAxisSpacing: 5,
      mainAxisExtent: size.height * 0.25,
    );
    return GridView.builder(
      itemCount: itemProducto?.length ?? 0,
      gridDelegate: grid,
      itemBuilder: (context, index) {
        Producto? producto = itemProducto![index];

        return GestureDetector(
          onTap: () => onProductTap(index, producto, joinedCantidad),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: borderColor)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                    height: size.height * 0.165,
                    child: const ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      child: FadeInImage(
                          fit: BoxFit.fill,
                          placeholder: AssetImage('assets/images/load.gif'),
                          image: NetworkImage(
                              "https://s1.eestatic.com/2021/07/12/actualidad/595952167_195030066_1706x960.jpg")),
                    )),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        producto!.producto,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        '${producto.precio} €',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
