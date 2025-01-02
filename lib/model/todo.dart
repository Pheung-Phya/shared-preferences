import 'dart:convert';

class Todo {
  final String title;
  final String description;
  final DateTime dateTime;

  Todo({
    required this.title,
    required this.description,
    required this.dateTime,
  });

  // Convert Todo to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
    };
  }

  // Create Todo from Map
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      description: map['description'],
      dateTime: DateTime.parse(map['dateTime']),
    );
  }

  // Convert Todo to JSON string
  String toJson() => json.encode(toMap());

  // Create Todo from JSON string
  factory Todo.fromJson(String source) => Todo.fromMap(json.decode(source));
}
