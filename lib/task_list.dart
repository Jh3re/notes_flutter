import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'task.dart';
import 'task_detail.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late CollectionReference taskCollection;
  TextEditingController _taskController = TextEditingController();
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    taskCollection = FirebaseFirestore.instance.collection('tasks');
    _loadTasks();
  }

  void _loadTasks() async {
  QuerySnapshot querySnapshot = await taskCollection.get();
  setState(() {
    tasks = querySnapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Task(
        id: doc.id,
        name: data['name'] as String,
        isDone: data['isDone'] as bool,
      );
    }).toList();
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(tasks[index].name),
            subtitle: Text(tasks[index].details),
            leading: Checkbox(
              value: tasks[index].isDone,
              onChanged: (value) {
                _updateTaskStatus(index, value!);
              },
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(index);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.info),
                  onPressed: () {
                    _viewTaskDetails(context, tasks[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        tooltip: 'Añadir Tarea',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
  if (context != null) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Añadir Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                decoration: InputDecoration(labelText: 'Nombre de la tarea'),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(_taskController.text);
                },
                child: Text('Añadir'),
              ),
            ],
          ),
        );
      },
    ).then((taskName) {
      if (taskName != null && taskName.isNotEmpty) {
        _addTask(taskName);
      }
      _taskController.clear();
    });
  } else {
    // Caso en el que no hay una interfaz de usuario disponible
    print("No hay una interfaz de usuario disponible para mostrar el cuadro de diálogo.");
    // Puedes tomar acciones adicionales aquí, según tus necesidades.
  }
}

  void _addTask(String taskName) async {
    await taskCollection.add(Task(name: taskName, id: '').toMap());
    _loadTasks();
    _taskController.clear();
  }

  void _deleteTask(int index) async {
    await taskCollection.doc(tasks[index].id).delete();
    _loadTasks();
  }

  void _updateTaskStatus(int index, bool isDone) async {
    await taskCollection.doc(tasks[index].id).update({'isDone': isDone});
    _loadTasks();
  }

  void _viewTaskDetails(BuildContext context, Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetail(task: task),
      ),
    );
  }
}
