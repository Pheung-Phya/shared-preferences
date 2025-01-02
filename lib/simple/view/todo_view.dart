import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package
import '../controller/todo_controller.dart';
import '../model/todo.dart';

class TodoView extends StatefulWidget {
  const TodoView({super.key});

  @override
  _TodoViewState createState() => _TodoViewState();
}

class _TodoViewState extends State<TodoView> {
  final TodoController _controller = TodoController();
  List<Todo> _todos = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController =
      TextEditingController(); // New controller for date
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTodos();
    _dateController.text = DateFormat('yyyy-MM-dd')
        .format(_selectedDate); // Initialize date controller
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
    _dateController.clear();
    setState(() {
      _selectedDate = DateTime.now();
    });
    _loadTodos();
  }

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
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }
  }

  void _showEditBottomSheet(int index) {
    final todo = _todos[index];
    _titleController.text = todo.title;
    _descriptionController.text = todo.description;
    _selectedDate = todo.dateTime;
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);

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
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: 'Select Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
              const SizedBox(height: 20),
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
                  _dateController.clear();
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                  _loadTodos();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
              TextButton(
                onPressed: () {
                  _titleController.clear();
                  _descriptionController.clear();
                  _dateController.clear();
                  setState(() {
                    _selectedDate = DateTime.now();
                  });
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
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
          const SizedBox(height: 20),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(
              labelText: 'Select Date',
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              _addTodo();
            },
            child: const Text('Add Todo'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
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
                        onPressed: () => _showEditBottomSheet(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
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
