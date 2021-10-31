import 'package:enum_to_string/enum_to_string.dart';

enum PriorityLevel { low, medium, high }

class Todo {
  final int? id;
  final String name;
  final DateTime date;
  final PriorityLevel priorityLevel;
  final bool completed;

  const Todo(
      {this.id,
      required this.name,
      required this.priorityLevel,
      required this.completed,
      required this.date});

  Todo copyWith({
    int? id,
    String? name,
    DateTime? date,
    PriorityLevel? priorityLevel,
    bool? completed,
  }) {
    return Todo(
        name: name ?? this.name,
        priorityLevel: priorityLevel ?? this.priorityLevel,
        completed: completed ?? this.completed,
        date: date ?? this.date,
        id: id ?? this.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'priority_level': EnumToString.convertToString(priorityLevel),
      'completed': completed ? 1 : 0,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
        id: map['id'] as int,
        name: map['name'] as String,
        priorityLevel: EnumToString.fromString(
            PriorityLevel.values, map['priorityLevel'] as String)!,
        completed: map['completed'] as int == 1,
        date: DateTime.parse(map['date'] as String));
  }
}
