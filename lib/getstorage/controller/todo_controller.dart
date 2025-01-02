import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

import 'package:share_preference/getstorage/model/todo.dart';

class TodoController extends GetxController {
  var todos = <Todo>[].obs;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  void loadTodos() {
    final todosString = _storage.read<String>('todos') ?? '[]';
    final todosList = List<Map<String, dynamic>>.from(json.decode(todosString));
    todos.value = todosList.map((e) => Todo.fromMap(e)).toList();
  }

  void addTodo(Todo todo) {
    todos.add(todo);
    _saveTodos();
  }

  void updateTodo(int index, Todo updatedTodo) {
    todos[index] = updatedTodo;
    _saveTodos();
  }

  void deleteTodo(int index) {
    todos.removeAt(index);
    _saveTodos();
  }

  void _saveTodos() {
    final todosList = todos.map((e) => e.toMap()).toList();
    _storage.write('todos', json.encode(todosList));
  }
}
