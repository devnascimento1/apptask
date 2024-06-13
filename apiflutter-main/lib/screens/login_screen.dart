import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/database_helper.dart';
import 'register_screen.dart';
import 'task_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final usuario = TextEditingController();
  final senha = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool seVisivel = false;
  bool seLoginVerdadeiro = false;

  Future<void> login() async {
    var dbHelper = DatabaseHelper();
    var user = await dbHelper.getUser(usuario.text, senha.text);
    if (user != null) {
      Get.to(() => const TaskListScreen());
    } else {
      setState(() {
        seLoginVerdadeiro = true;
      });
    }
  }

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
                  const Text(
                    "ToDo App",
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
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
                        return "Por favor, insira a senha";
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          login();
                        }
                      },
                      child: const Text("LOGIN"),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Não tem uma conta?"),
                      TextButton(
                        onPressed: () {
                          Get.to(() => const RegisterScreen());
                        },
                        child: const Text("Cadastre-se"),
                      ),
                    ],
                  ),
                  seLoginVerdadeiro
                      ? const Text(
                          "Usuário ou Senha incorretos",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
