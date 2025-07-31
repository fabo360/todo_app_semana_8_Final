import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  final int index;

  const TaskDetailScreen({super.key, required this.task, required this.index});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Task _task;

  @override
  void initState() {
    super.initState();
    _task = widget.task;
    _titleController = TextEditingController(text: _task.title);
    _descriptionController = TextEditingController(text: _task.description);
  }

  Future<void> _saveEditedTask() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];

    _task = Task(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      createdAt: _task.createdAt,
      isCompleted: _task.isCompleted,
    );

    taskList[widget.index] = json.encode(_task.toMap());
    await prefs.setStringList('tasks', taskList);

    Navigator.pop(context, _task);
  }

  Future<void> _deleteTask() async {
    final prefs = await SharedPreferences.getInstance();
    final taskList = prefs.getStringList('tasks') ?? [];

    taskList.removeAt(widget.index);
    await prefs.setStringList('tasks', taskList);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de Tarea")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha de creación: ${_task.createdAt.toLocal()}",
                style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _saveEditedTask,
                  child: const Text('Guardar cambios'),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _deleteTask,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Eliminar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


