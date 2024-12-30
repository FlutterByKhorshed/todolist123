import 'package:flutter/material.dart';
import '../models/task.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import 'completed_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  final List<Task> _completedTasks = [];

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _editTask(int index, Task updatedTask) {
    setState(() {
      _tasks[index] = updatedTask;
    });
  }

  void _deleteTask(int index, bool fromCompleted) {
    setState(() {
      if (fromCompleted) {
        _completedTasks.removeAt(index);
      } else {
        _tasks.removeAt(index);
      }
    });
  }

  void _toggleTaskComplete(int index, bool fromCompleted) {
    setState(() {
      if (fromCompleted) {
        final task = _completedTasks.removeAt(index);
        task.isCompleted = false;
        _tasks.add(task);
      } else {
        final task = _tasks.removeAt(index);
        task.isCompleted = true;
        _completedTasks.add(task);
      }
    });
  }

  void _navigateToCompletedTasksScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CompletedTasksScreen(
          tasks: _completedTasks,
          onDelete: (index) {
            setState(() {
              _completedTasks.removeAt(index);
            });
          },
          onUndo: (index) {
            setState(() {
              final task = _completedTasks.removeAt(index);
              task.isCompleted = false;
              _tasks.add(task);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
        backgroundColor: Colors.teal,
        actions: [
          TextButton(
            onPressed: _navigateToCompletedTasksScreen,
            child: const Text(
              'Completed Tasks',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: _tasks.isEmpty
          ? const Center(
        child: Text(
          'No tasks added yet!',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            elevation: 4,
            child: ListTile(
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
              subtitle: Text('Priority: ${task.priority}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => _toggleTaskComplete(index, false),
                    child: const Text('Complete'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index, false),
                  ),
                ],
              ),
              onTap: () async {
                final updatedTask = await Navigator.push<Task>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                );
                if (updatedTask != null) {
                  _editTask(index, updatedTask);
                }
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push<Task>(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          );
          if (newTask != null) {
            _addTask(newTask);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
