import 'package:flutter/material.dart';
import 'package:todos/models/todo.model.dart';
import 'package:todos/screens/addTodo.screen.dart';
import 'package:todos/services/database.service.dart';
import 'package:todos/widget/TodoTile.widget.dart';
import 'package:todos/widget/TodosOverview.widget.dart';

class TodoListScreen extends StatefulWidget {
  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _getTodos();
  }

  Future<void> _getTodos() async {
    final todos = await DatabaseService.instance.getAllTodos();
    if (mounted) {
      setState(() => _todos = todos);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 32.0),
          itemCount: 1 + _todos.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) return TodosOverview(todos: _todos);
            final todo = _todos[index - 1];
            return TodoTile(
              todo: todo,
              updateTodos: _getTodos,
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            fullscreenDialog: true,
            builder: (_) => AddTodoScreen(
              updateTodos: _getTodos,
            ),
          ),
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
