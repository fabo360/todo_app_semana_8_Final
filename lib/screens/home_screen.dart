import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:todo_app/models/task.dart';
import 'package:todo_app/providers/tasks_provider.dart';
import 'package:todo_app/providers/theme_provider.dart';
import 'package:todo_app/screens/add_task_screen.dart';
import 'package:todo_app/screens/task_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _listKey = GlobalKey<AnimatedListState>();

  // ---- Item builder con animación ----
  Widget _buildItem(Task t, int index, Animation<double> animation) {
    final provider = context.read<TasksProvider>();
    return SizeTransition(
      sizeFactor: animation,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: Checkbox(
            value: t.done,
            onChanged: (v) => provider.toggleDone(index, v ?? false),
          ),
          title: Text(
            t.title,
            style: TextStyle(
              decoration: t.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: t.notes.isNotEmpty
              ? Text(
                  t.notes,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Eliminar',
            onPressed: () => _removeAt(index),
          ),
          onTap: () => _irADetalle(t),
        ),
      ),
    );
  }

  // ---- Acciones ----
  void _insertTask(String title) {
    final provider = context.read<TasksProvider>();
    final index = provider.length; // índice antes de insertar
    provider.addAtEnd(Task(title.trim())); // estado global
    _listKey.currentState
        ?.insertItem(index, duration: const Duration(milliseconds: 300));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarea agregada')),
    );
  }

  void _removeAt(int index) {
    final provider = context.read<TasksProvider>();
    final removed = provider.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, animation) => _buildItem(removed, index, animation),
      duration: const Duration(milliseconds: 300),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarea eliminada: ${removed.title}'),
        action: SnackBarAction(
          label: 'DESHACER',
          onPressed: () {
            provider.addAtEnd(removed);
            final i = provider.length - 1;
            _listKey.currentState
                ?.insertItem(i, duration: const Duration(milliseconds: 300));
          },
        ),
      ),
    );
  }

  Future<void> _irANuevaTarea() async {
    final String? titulo = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddTaskScreen()),
    );
    if (titulo != null && titulo.trim().isNotEmpty) {
      _insertTask(titulo);
    }
  }

  Future<void> _irADetalle(Task t) async {
    final refreshed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailScreen(task: t)),
    );
    if (refreshed == true) {
      // El provider ya notificó; forzamos rebuild local por si acaso.
      setState(() {});
    }
  }

  // ---- Build ----
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TasksProvider>();

    if (!provider.isLoaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Lista de Tareas',
        style: TextStyle(color: Colors.white),
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (_, theme, __) => IconButton(
              tooltip:
                  theme.mode == ThemeMode.dark ? 'Modo claro' : 'Modo oscuro',
              icon: Icon(
                theme.mode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () => theme.toggle(),
            ),
          ),
        ],
      ),
      body: provider.tasks.isEmpty
          ? const Center(child: Text('No hay tareas. ¡Agrega la primera!'))
          : AnimatedList(
              key: _listKey,
              initialItemCount: provider.length,
              itemBuilder: (context, index, animation) =>
                  _buildItem(provider.tasks[index], index, animation),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _irANuevaTarea,
        child: const Icon(Icons.add),
      ),
    );
  }
}
