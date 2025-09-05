import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../models/task.dart';

class TasksProvider extends ChangeNotifier {
  static const _prefsKey = 'tasks_v2';
  final List<Task> _tasks = [];
  bool _loaded = false;

  bool get isLoaded => _loaded;
  List<Task> get tasks => List.unmodifiable(_tasks);
  int get length => _tasks.length;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey);
    if (raw != null) {
      final list = Task.decodeList(raw);
      _tasks
        ..clear()
        ..addAll(list);
    } else {
      // Datos iniciales (opcionales)
      _tasks.addAll([
        Task('Estudiar Flutter'),
        Task('Hacer compras'),
        Task('Revisar correos'),
        Task('Leer un libro'),
        Task('Practicar ejercicios'),
      ]);
    }
    _loaded = true;
    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, Task.encodeList(_tasks));
  }

  // --- Mutadores ---
  void addAtEnd(Task t) {
    _tasks.add(t);
    _persist();
    notifyListeners();
  }

  Task removeAt(int index) {
    final removed = _tasks.removeAt(index);
    _persist();
    notifyListeners();
    return removed;
  }

  void toggleDone(int index, bool value) {
    _tasks[index].done = value;
    _persist();
    notifyListeners();
  }

  void updateTask(Task t) {
    // Como t es la misma referencia, solo persistimos y notificamos
    _persist();
    notifyListeners();
  }
}
