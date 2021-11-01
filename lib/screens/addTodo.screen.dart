import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todos/models/todo.model.dart';
import 'package:todos/extensions/stringCapitalize.dart';
import 'package:todos/services/database.service.dart';

class AddTodoScreen extends StatefulWidget {
  final VoidCallback updateTodos;
  final Todo? todo;

  const AddTodoScreen({required this.updateTodos, this.todo});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _dateController;

  Todo? _todo;

  bool get _isEditing => widget.todo != null;

  @override
  void initState() {
    super.initState();

    if (_isEditing) {
      _todo = widget.todo;
    } else {
      _todo = Todo(
        name: '',
        priorityLevel: PriorityLevel.medium,
        completed: false,
        date: DateTime.now(),
      );
    }

    _nameController = TextEditingController(text: _todo!.name);
    _dateController =
        TextEditingController(text: DateFormat.MMMMEEEEd().format(_todo!.date));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(!_isEditing ? 'Add todo' : 'Update Todo'),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value!.trim().isEmpty ? 'Please enter a name' : null,
                  onSaved: (value) => _todo = _todo!.copyWith(name: value),
                ),
                SizedBox(height: 32.0),
                TextFormField(
                  controller: _dateController,
                  style: TextStyle(fontSize: 16.0),
                  readOnly: true,
                  decoration: InputDecoration(labelText: 'Date'),
                  onTap: _handleDatePicker,
                ),
                SizedBox(height: 32.0),
                DropdownButtonFormField<PriorityLevel>(
                  value: _todo!.priorityLevel,
                  icon: Icon(Icons.arrow_drop_down_circle),
                  iconEnabledColor: Theme.of(context).primaryColor,
                  items: PriorityLevel.values
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            EnumToString.convertToString(e).capitalize(),
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                          ),
                        ),
                      )
                      .toList(),
                  style: TextStyle(fontSize: 16.0),
                  decoration: InputDecoration(labelText: 'Priority Level'),
                  onChanged: (value) => setState(() {
                    _todo = _todo!.copyWith(priorityLevel: value);
                  }),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _submit,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        !_isEditing ? Colors.green : Colors.orange),
                    minimumSize: MaterialStateProperty.all(
                      Size.fromHeight(45.0),
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  child: Text(
                    !_isEditing ? 'Add' : 'Save',
                    style: TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                if (_isEditing)
                  ElevatedButton(
                    onPressed: () {
                      DatabaseService.instance.delete(_todo!.id!);
                      widget.updateTodos();
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                      minimumSize: MaterialStateProperty.all(
                        Size.fromHeight(45.0),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    child: Text(
                      'Delete',
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _todo!.date,
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (date != null) {
      _dateController.text = DateFormat.MMMMEEEEd().format(date);
      setState(() {
        _todo = _todo!.copyWith(date: date);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (!_isEditing) {
        DatabaseService.instance.insert(_todo!);
      } else {
        DatabaseService.instance.update(_todo!);
      }

      widget.updateTodos();

      Navigator.of(context).pop();
    }
  }
}
