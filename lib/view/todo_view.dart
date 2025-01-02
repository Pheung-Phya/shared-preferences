import 'package:flutter/material.dart';
import '../controller/todo_controller.dart';
import '../model/todo.dart';

class TodoView extends StatefulWidget {
  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TodoController _controller = TodoController();
  List<Todo> _todos = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await _controller.getTodos();
    setState(() {
      _todos = todos;
    });
  }

  void _addTodo() async {
    final todo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      dateTime: _selectedDate,
    );
    await _controller.addTodo(todo);
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedDate = DateTime.now(); // Reset date after adding todo
    });
    _loadTodos();
  }

  // Show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Method to show the bottom sheet for editing the todo
  void _showEditBottomSheet(int index) {
    final todo = _todos[index];
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    _selectedDate = todo.dateTime;

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              SizedBox(height: 20),
              // Display selected date
              Text('Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => _selectDate(context), // Open DatePicker
                child: Text('Pick a Date'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final updatedTodo = Todo(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    dateTime: _selectedDate,
                  );
                  await _controller.updateTodo(index, updatedTodo);
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedDate =
                        DateTime.now(); // Reset date after updating todo
                  });
                  _loadTodos();
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  // Clear the controllers when Cancel is pressed
                  _titleController.clear();
                  _descriptionController.clear();
                  setState(() {
                    _selectedDate = DateTime.now(); // Reset the date
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteTodo(int index) async {
    await _controller.deleteTodo(index);
    _loadTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo App')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
          ),
          SizedBox(height: 20),
          // Display selected date
          Text('Selected Date: ${_selectedDate.toLocal()}'.split(' ')[0]),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              // Add todo with selected date
              _addTodo();
            },
            child: Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  title: Text(todo.title),
                  subtitle: Text(todo.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () =>
                            _showEditBottomSheet(index), // Show bottom sheet
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteTodo(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
