import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/database_helper.dart';
import '../models/user.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final usuario = TextEditingController();
  final senha = TextEditingController();
  final confirmarSenha = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool seVisivel = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ListTile(
                    title: Text(
                      "Registre nova conta",
                      style:
                          TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextFormField(
                    controller: usuario,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira o nome de usuário";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      hintText: 'Usuário',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: senha,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, insira uma senha";
                      }
                      return null;
                    },
                    obscureText: !seVisivel,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      hintText: 'Senha',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            seVisivel = !seVisivel;
                          });
                        },
                        icon: Icon(seVisivel
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: confirmarSenha,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Por favor, o campo de Confirma senha não pode ser vazio";
                      } else if (senha.text != confirmarSenha.text) {
                        return "As senhas não coincidem";
                      }
                      return null;
                    },
                    obscureText: !seVisivel,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.lock),
                      border: const OutlineInputBorder(),
                      hintText: 'Confirmar Senha',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            seVisivel = !seVisivel;
                          });
                        },
                        icon: Icon(seVisivel
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          var newUser = User(
                              username: usuario.text, password: senha.text);
                          await DatabaseHelper().insertUser(newUser);
                          Get.snackbar(
                              'Sucesso', 'Usuário cadastrado com sucesso',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white);
                          Future.delayed(const Duration(seconds: 2), () {
                            Get.to(() => const LoginScreen());
                          });
                        }
                      },
                      child: const Text('Cadastrar'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Já tem uma conta?'),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const LoginScreen());
                        },
                        child: const Text('LOGIN'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
