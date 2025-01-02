import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controller/todo_controller.dart';
import '../model/todo.dart';

class TodoView extends StatefulWidget {
  @override
  State<TodoView> createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TodoController _controller = Get.put(TodoController());

  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      _selectedDate = picked;
      _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
    }
  }

  void _addTodo() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Title and Description cannot be empty');
      return;
    }

    final todo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: _selectedDate,
    );
    _controller.addTodo(todo);
    _titleController.clear();
    _descriptionController.clear();
    _dateController.clear();
  }

  void _showEditBottomSheet(BuildContext context, int index) {
    final todo = _controller.todos[index];
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    _selectedDate = todo.dateTime;
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);

    Get.bottomSheet(
      backgroundColor: Colors.white,
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                labelText: 'Select Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            ElevatedButton(
              onPressed: () {
                final updatedTodo = Todo(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  dateTime: _selectedDate,
                );
                _controller.updateTodo(index, updatedTodo);
                _titleController.clear();
                _descriptionController.clear();
                _dateController.clear();
                Get.back();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                _titleController.clear();
                _descriptionController.clear();
                _dateController.clear();
                Get.back();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Select Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          ElevatedButton(
            onPressed: _addTodo,
            child: const Text('Add Todo'),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: _controller.todos.length,
                itemBuilder: (context, index) {
                  final todo = _controller.todos[index];
                  final formattedDate =
                      DateFormat('yyyy-MM-dd').format(todo.dateTime);
                  return ListTile(
                    title: Text(todo.title),
                    subtitle: Text('${todo.description}\nDate: $formattedDate'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _showEditBottomSheet(context, index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _controller.deleteTodo(index),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
