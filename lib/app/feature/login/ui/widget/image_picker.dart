import 'package:flutter/material.dart';

class ImagePicker extends StatelessWidget {
  const ImagePicker({
    super.key,
    required this.ratio,
  });

  final double ratio;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.height * ratio,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * ratio,
                child: Card(
                  elevation: 15.0,
                  child: Icon(
                    Icons.image,
                    size: 125,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: ElevatedButton(
                    onPressed: () {}, child: const Text('Agregar Foto')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
