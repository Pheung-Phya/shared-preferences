import '../model/todo.dart';
import '../service/todo_service.dart';

class TodoController {
  final TodoService _todoService = TodoService();
  Future<List<Todo>> getTodos() async {
    return await _todoService.loadTodos();
  }

  Future<void> addTodo(Todo todo) async {
    await _todoService.addTodo(todo);
  }

  Future<void> updateTodo(int index, Todo updatedTodo) async {
    await _todoService.updateTodo(index, updatedTodo);
  }

  Future<void> deleteTodo(int index) async {
    await _todoService.deleteTodo(index);
  }
}
