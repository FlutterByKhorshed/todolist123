import 'package:flutter/material.dart';
import '../models/task.dart';

class CompletedTasksScreen extends StatelessWidget {
  final List<Task> tasks;
  final void Function(int index) onDelete;
  final void Function(int index) onUndo;

  const CompletedTasksScreen({
    Key? key,
    required this.tasks,
    required this.onDelete,
    required this.onUndo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Tasks'),
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: tasks.isEmpty
          ? const Center(
        child: Text(
          'No completed tasks yet!',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            child: ListTile(
              title: Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              subtitle: Text('Priority: ${task.priority}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => onUndo(index),
                    child: const Text('Undo'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
