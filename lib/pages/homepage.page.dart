import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: const TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList> {
  final TextEditingController taskController = TextEditingController();
  final List<String> tasks = [];
  String? errorText;
  int? editingIndex;
  bool _isLoading = false; // Variável para controlar o carregamento
  bool _isDeleting =
      false; // Variável para indicar se a exclusão está em andamento

  void addTask() async {
    setState(() {
      _isLoading = true; // Mostra o indicador de progresso
    });

    String task = taskController.text.trim();

    if (task.isEmpty || task.length < 3) {
      setState(() {
        errorText = 'A tarefa deve ter pelo menos 3 caracteres.';
        _isLoading = false; // Oculta o indicador de progresso
      });
      return;
    }

    await Future.delayed(const Duration(
        seconds: 1)); // Simula um atraso para mostrar o indicador

    setState(() {
      if (editingIndex != null) {
        tasks[editingIndex!] = task;
        editingIndex = null;
      } else {
        tasks.add(task);
      }
      errorText = null;
      _isLoading = false; // Oculta o indicador de progresso
    });

    taskController
        .clear(); // Limpa o Text field depois de adicionar ou editar uma tarefa
  }

  void startEditTask(int index) {
    setState(() {
      taskController.text = tasks[index];
      editingIndex = index; // Marca a tarefa como editada
    });
  }

  Future<void> removeTask(int index) async {
    setState(() {
      _isLoading = true; // Mostra o indicador de progresso
      _isDeleting = true; // Marca que a exclusão está em andamento
    });

    await Future.delayed(const Duration(
        seconds: 2)); // Aguarda 2 segundos antes de remover a tarefa

    setState(() {
      tasks.removeAt(index);
      _isLoading = false; // Oculta o indicador de progresso
      _isDeleting = false; // Marca que a exclusão foi concluída
    });
  }

  void _onLongPress(int index) {
    if (_isDeleting) {
      return; // Ignora o evento se já estiver excluindo
    }

    // Inicia o processo de exclusão após um atraso de 2 segundos
    removeTask(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: taskController,
                  decoration: InputDecoration(
                    labelText: 'Digite Sua Tarefa',
                    errorText: errorText,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : addTask, // Desativa o botão durante o carregamento
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                ),
                child: Text(editingIndex != null ? 'Atualizar' : 'Adicionar'),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          const Text(
            'Tarefas',
            style: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 8.0),
          Expanded(
            child: tasks.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_isLoading) // Exibe o indicador de progresso quando _isLoading é verdadeiro
                        const Center(child: CircularProgressIndicator()),
                      if (!_isLoading) // Exibe a imagem e o texto apenas quando não estiver carregando
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/emptylist.png'),
                            const SizedBox(height: 16.0),
                            const Text('Nenhuma tarefa adicionada',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                    ],
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(tasks[index]),
                        onDismissed: (direction) {
                          // Não é necessário fazer nada aqui, pois a exclusão é tratada no onLongPress
                        },
                        background: Container(color: Colors.red),
                        child: Card(
                          color: Colors.redAccent.withOpacity(0.3),
                          child: ListTile(
                            title: Text(tasks[index]),
                            tileColor: Colors.redAccent.withOpacity(0.2),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  onPressed: _isLoading
                                      ? null
                                      : () => startEditTask(
                                          index), // Desativa o botão durante o carregamento
                                ),
                                GestureDetector(
                                  onLongPress: () => _onLongPress(
                                      index), // Usa onLongPress para iniciar o atraso de exclusão
                                  child: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
