import 'package:flutter/material.dart';
import 'package:jarv/src/data_source/db.dart';
import 'package:jarv/src/widgets/card_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.usuarios,
  });

  final UsuarioDao usuarios;

  static const routeName = "/login";

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final selectedUserIndex = ValueNotifier<int?>(null);
  bool showInputPassword = false;

  @override
  Widget build(BuildContext context) {
    final Future<List<Usuario>> listUsuarios =
        widget.usuarios.findAllUsuarios();

    return Scaffold(
      appBar: AppBar(
        leading: const Center(child: Text("JARV")),
        centerTitle: true,
        title: const Text("dd/mm/aaaa"),
        actions: [
          Center(
              child: IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, "/settings");
            },
          ))
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 10.0),
                child: FutureBuilder(
                    future: listUsuarios,
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      return GridView.builder(
                        itemCount: user?.length ?? 0,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    3, // number of items in each row
                                mainAxisSpacing: 0, // spacing between rows
                                crossAxisSpacing: 10,
                                mainAxisExtent: 180),
                        itemBuilder: (context, index) {
                          final userUser = user![index];
                          return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedUserIndex.value == index) {
                                    showInputPassword = false;
                                    selectedUserIndex.value = null;
                                  } else {
                                    showInputPassword = true;
                                    selectedUserIndex.value = index;
                                  }
                                });
                              },
                              child: CardButton(
                                  content: userUser.nombre,
                                  valueNotifier: selectedUserIndex,
                                  colorSelected:
                                      const Color.fromARGB(255, 10, 0, 141),
                                  posicion: index));
                        },
                      );
                    }),
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
              visible: showInputPassword,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: TextFormField(
                        decoration: const InputDecoration(
                      icon: Icon(Icons.password),
                      labelText: 'Password',
                    )),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/menu");
                      },
                      child: const Text("Ingresar")),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
