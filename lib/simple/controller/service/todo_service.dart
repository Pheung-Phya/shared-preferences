import 'package:shared_preferences/shared_preferences.dart';
import '../../model/todo.dart';

class TodoService {
  static const String _keyTodos = 'todos';

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = todos.map((todo) => todo.toJson()).toList();
    await prefs.setStringList(_keyTodos, todoList);
  }

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = prefs.getStringList(_keyTodos) ?? [];
    return todoList.map((todo) => Todo.fromJson(todo)).toList();
  }

  Future<void> addTodo(Todo todo) async {
    final todos = await loadTodos();
    todos.add(todo);
    await saveTodos(todos);
  }

  Future<void> deleteTodo(int index) async {
    final todos = await loadTodos();
    todos.removeAt(index);
    await saveTodos(todos);
  }

  Future<void> updateTodo(int index, Todo updatedTodo) async {
    final todos = await loadTodos();
    todos[index] = updatedTodo;
    await saveTodos(todos);
  }
}
