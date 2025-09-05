import 'dart:convert';

class Task {
  String title;
  bool done;
  final DateTime createdAt;
  String notes;

  Task(
    this.title, {
    this.done = false,
    this.notes = '',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'title': title,
        'done': done,
        'notes': notes,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Task.fromMap(Map<String, dynamic> map) => Task(
        map['title'] ?? '',
        done: map['done'] ?? false,
        notes: map['notes'] ?? '',
        createdAt: DateTime.parse(map['createdAt']),
      );

  static String encodeList(List<Task> tasks) =>
      jsonEncode(tasks.map((t) => t.toMap()).toList());

  static List<Task> decodeList(String raw) =>
      (jsonDecode(raw) as List).map((m) => Task.fromMap(m)).toList();
}
