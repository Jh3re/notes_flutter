// TODO Implement this library.
import 'package:flutter/material.dart';
import 'task.dart';
 
class TaskDetail extends StatelessWidget {
  final Task task;
 
  TaskDetail({required this.task});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalle'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Task: ${task.name}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Detalles: ${task.details}',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}