// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:todos/models/todo.model.dart';

class TodosOverview extends StatelessWidget {
  final List<Todo> todos;

  const TodosOverview({required this.todos});

  @override
  Widget build(BuildContext context) {
    final completedTodosCount = todos.where((e) => e.completed).length;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        // ignore: prefer_const_literals_to_create_immutables
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'My Todo',
            style: TextStyle(
              fontSize: 28.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            '$completedTodosCount of ${todos.length} completed',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }
}
