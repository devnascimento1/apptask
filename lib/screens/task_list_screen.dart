import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/database_helper.dart';
import '../models/task.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late DatabaseHelper _dbHelper;
  late Future<List<Task>> _taskList;

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _refreshTaskList();
  }

  void _refreshTaskList() {
    setState(() {
      _taskList = _dbHelper.getTasks();
    });
  }

  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _refreshTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: FutureBuilder<List<Task>>(
        future: _taskList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar tarefas'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa encontrada'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Task task = snapshot.data![index];
                
                return Dismissible(
                  key: Key(task.id.toString()),
                  background: Container(color: Colors.red),
                  secondaryBackground: Container(color: Colors.green),
                  confirmDismiss: (direction) async {
                    if (direction == DismissDirection.endToStart) {
                      bool? confirmDelete = await showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Excluir Tarefa'),
                            content: const Text(
                                'Deseja realmente excluir esta tarefa?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: const Text('Excluir'),
                              ),
                            ],
                          );
                        },
                      );
                      return confirmDelete ?? false;
                    } else if (direction == DismissDirection.startToEnd) {
                      Get.to(() => TaskFormScreen(task: task))
                          ?.then((_) => _refreshTaskList());
                      return false;
                    }
                    return false;
                  },
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      _deleteTask(task.id!);
                    }
                  },
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(task.description ?? ''),
                    trailing: Checkbox(
                      value: task.isCompleted,
                      onChanged: (bool? value) {
                        setState(() {
                          task.isCompleted = value ?? false;
                        });
                        _dbHelper.updateTask(task);
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const TaskFormScreen())?.then((_) => _refreshTaskList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
