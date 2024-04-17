import 'package:flutter/material.dart';

import '../../app/feature/venta/data/repositories/interfaces/menu_repository.dart';
import '../../core/di/locator.dart';

class MainFilter extends StatelessWidget {
  const MainFilter({
    super.key,
    required this.familia,
    required this.familiaId,
    required this.subFamilia,
    required this.onChangeFamilia,
    required this.onChangeSubFamilia,
  });

  final String? familia;
  final String familiaId;
  final String? subFamilia;
  final dynamic onChangeFamilia;
  final dynamic onChangeSubFamilia;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.5,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.75,
              child: FamiliaSelector(
                familia: familia,
                onChanged: (value) {
                  onChangeFamilia(value);
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 4.75,
              child: SubFamiliaSelector(
                familiaId: familiaId,
                subFamilia: subFamilia,
                onChanged: (value) {
                  onChangeSubFamilia(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubFamiliaSelector extends StatelessWidget {
  const SubFamiliaSelector({
    super.key,
    required this.familiaId,
    required this.subFamilia,
    required this.onChanged,
  });

  final String familiaId;
  final String? subFamilia;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    final fecthProductoRepository = localService<MenuRepository>();
    return StreamBuilder(
      stream: fecthProductoRepository.findSubFamiliaByFamilia(familiaId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButtonFormField(
            value: subFamilia,
            hint: const Text('Sub-Familia'),
            items: snapshot.data!
                .map((value) => DropdownMenuItem<String>(
                      value: value!.nombreSub,
                      child: Text(value.nombreSub),
                    ))
                .toList(),
            onChanged: (value) {
              onChanged(value);
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class FamiliaSelector extends StatelessWidget {
  const FamiliaSelector({
    super.key,
    required this.familia,
    required this.onChanged,
  });

  final String? familia;
  final dynamic onChanged;

  @override
  Widget build(BuildContext context) {
    final fecthProductoRepository = localService<MenuRepository>();

    return StreamBuilder(
      stream: fecthProductoRepository.findAllFamilias(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return DropdownButtonFormField(
            value: familia,
            hint: const Text('Familia'),
            items: snapshot.data!.map((value) {
              return DropdownMenuItem<String>(
                value: value.idFamilia,
                child: Text(value.nombreFamilia),
              );
            }).toList(),
            onChanged: (value) {
              onChanged(value);
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
