import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/tasks_provider.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;
  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    _notesCtrl = TextEditingController(text: widget.task.notes);
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  void _toggle(bool v) {
    setState(() => widget.task.done = v);
    context.read<TasksProvider>().updateTask(widget.task);
  }

  void _saveAndClose() {
    widget.task.notes = _notesCtrl.text.trim();
    context.read<TasksProvider>().updateTask(widget.task);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.task;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de tarea'),
        leading: BackButton(onPressed: _saveAndClose),
        actions: [
          IconButton(onPressed: _saveAndClose, icon: const Icon(Icons.check)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(t.title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text('Estado: '),
                Chip(
                  label: Text(t.done ? 'Completada' : 'Pendiente'),
                  backgroundColor:
                      t.done ? Colors.green.shade100 : Colors.orange.shade100,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Creada: ${t.createdAt.toLocal()}',
                style: Theme.of(context).textTheme.bodySmall),
            const Divider(height: 24),
            Text('Notas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _notesCtrl,
              minLines: 4,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'Escribe aquí tus notas…',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              value: t.done,
              title: const Text('Marcar como completada'),
              onChanged: _toggle,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveAndClose,
        icon: const Icon(Icons.save),
        label: const Text('Guardar'),
      ),
    );
  }
}

