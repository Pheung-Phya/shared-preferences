import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/todo.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosString = prefs.getString('todos') ?? '[]';
    final todosList = List<Map<String, dynamic>>.from(json.decode(todosString));
    todos.value = todosList.map((e) => Todo.fromMap(e)).toList();
  }

  Future<void> addTodo(Todo todo) async {
    todos.add(todo);
    await _saveTodos();
  }

  Future<void> updateTodo(int index, Todo updatedTodo) async {
    todos[index] = updatedTodo;
    await _saveTodos();
  }

  Future<void> deleteTodo(int index) async {
    todos.removeAt(index);
    await _saveTodos();
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todosList = todos.map((e) => e.toMap()).toList();
    await prefs.setString('todos', json.encode(todosList));
  }
}
