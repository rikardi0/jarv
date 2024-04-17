import 'package:flutter/material.dart';
import 'package:jarv/app/feature/inventario/data/repositories/interface/inventario_repository.dart';

import '../../../../../core/di/locator.dart';

import 'package:jarv/shared/ui/filter_familia_subfamilia.dart';

class InventarioView extends StatefulWidget {
  const InventarioView({super.key});
  static const routeName = '/inventario';

  @override
  State<InventarioView> createState() => _InventarioViewState();
}

class _InventarioViewState extends State<InventarioView> {
  final fetchRepository = localService<InventarioRepository>();
  String familiaId = '';
  String? subFamilia;
  String? familia;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventario'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MainFilter(
                familia: familia,
                familiaId: familiaId,
                subFamilia: subFamilia,
                onChangeFamilia: (value) {
                  setState(() {
                    familiaId = value!;
                    subFamilia = null;
                  });
                },
                onChangeSubFamilia: (value) {
                  setState(() {
                    subFamilia = value;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.all(25.0),
                child: FutureBuilder(
                    future: fetchRepository.findAllProductos(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: 175,
                                width: 200,
                                child: Column(
                                  children: [
                                    const Text('Producto'),
                                    SizedBox(
                                      height: 175,
                                      width: 200,
                                      child: ListView.builder(
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: TextFormField(
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.red))),
                                              initialValue: snapshot
                                                  .data![index].producto,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
