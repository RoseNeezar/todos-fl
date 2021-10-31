import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/extensions/stringCapitalize.dart';
import 'package:todos/models/todo.model.dart';
import 'package:todos/services/database.service.dart';

class TodoTile extends StatelessWidget {
  final Todo todo;
  const TodoTile({
    Key? key,
    required this.todo,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final completedTextDecoration =
        !todo.completed ? TextDecoration.none : TextDecoration.lineThrough;
    return ListTile(
      title: Text(
        todo.name,
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
      subtitle: Row(
        children: <Widget>[
          Text(
            '${DateFormat.MMMMEEEEd().format(todo.date)}',
            style: TextStyle(
              height: 1.3,
              decoration: completedTextDecoration,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 2.5,
              horizontal: 8.0,
            ),
            decoration: BoxDecoration(
              color: _getColor(),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, 2),
                  blurRadius: 4.0,
                )
              ],
            ),
            child: Text(
              EnumToString.convertToString(todo.priorityLevel).capitalize(),
              style: TextStyle(
                color: !todo.completed ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
                decoration: completedTextDecoration,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
      trailing: Checkbox(
        value: todo.completed,
        activeColor: _getColor(),
        onChanged: (value) {
          DatabaseService.instance.update(todo.copyWith(completed: value));
        },
      ),
    );
  }

  Color _getColor() {
    switch (todo.priorityLevel) {
      case PriorityLevel.low:
        return Colors.green;
      case PriorityLevel.medium:
        return Colors.orange[600]!;
      case PriorityLevel.high:
        return Colors.red[400]!;
    }
  }
}
