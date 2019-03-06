import 'package:flutter/material.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_date_picker.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_form_field.dart';
import 'package:project_scarlet/widgets/strategy_widgets/combo_box.dart';

class TaskForm extends StatefulWidget {
  final TaskEntity inputTask;
  final Function addTask, updateTask;

  TaskForm(this.inputTask, this.addTask, this.updateTask);

  @override
  _TaskForm createState() => _TaskForm();
}

class _TaskForm extends State<TaskForm> {
  final Map<String, dynamic> _formData = taskFormData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameFocusNode = FocusNode(),
      _descriptionFocusNode = FocusNode(),
      _locationFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit task details',
            style: Theme.of(context).textTheme.title,
          ),
        ),
        body: _buildForm(context),
      ),
    );
  }

  /// This method creates and saves the task by using the [addTask] function
  /// passed into it.
  void _submitForm() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    _formData[columnData[7][0]] =
        (widget.inputTask != null) ? widget.inputTask.setDate : DateTime.now();

    final TaskEntity task = fromMap(_formData);
    widget.inputTask == null ? widget.addTask(task) : widget.updateTask(task);

    Navigator.pop(context);
  }

  Widget _buildForm(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width,
        targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95,
        targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        autovalidate: true,
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2.0),
          children: _buildChildren(),
        ),
      ),
    );
  }

  List<Widget> _buildChildren() {
    String name, description, location, buttonText = 'Add new task';
    int priority = 0, difficulty = 0;
    DateTime dueDate = DateTime.now();

    if (widget.inputTask != null) {
      name = widget.inputTask.name;
      description = widget.inputTask?.description == null
          ? ''
          : widget.inputTask.description;
      location =
          widget.inputTask?.location == null ? '' : widget.inputTask.location;
      priority = widget.inputTask.priority;
      difficulty = widget.inputTask.difficulty;
      dueDate = widget.inputTask.dueDate;
      buttonText = 'Update task';
    }

    final Map<String, List<dynamic>> textFieldParams = {
      'focusNode': [_nameFocusNode, _descriptionFocusNode, _locationFocusNode],
      'nextFocusNode': [_descriptionFocusNode, _locationFocusNode, null],
      'initialValue': [name, description, location],
      'label': [0, 2, 5],
      'fieldHint': ['E.g. Swimming', 'E.g. For 1 hour.', 'E.g. Swimming pool.'],
      'formKey': [columnData[0][0], columnData[2][0], columnData[5][0]],
    };
    final List<Widget> children = [];
    for (int i = 0; i < 3; ++i)
      children.add(TaskFormField(
        formData: _formData,
        fieldHint: textFieldParams['fieldHint'][i],
        focusNode: textFieldParams['focusNode'][i],
        initialValue: textFieldParams['initialValue'][i],
        labelText: textFieldParams['label'][i],
        nextFocusNode: textFieldParams['nextFocusNode'][i],
        formKey: textFieldParams['formKey'][i],
      ));
    children.add(SizedBox(height: 10.0));
    children.add(TaskDatePicker(_formData, columnData[1][0], dueDate));
    children.add(SizedBox(height: 10.0));
    children.add(Row(
      children: <Widget>[
        ComboBox(priorityData, _formData, columnData[3][0], priority),
        ComboBox(difficultyData, _formData, columnData[4][0], difficulty)
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ));
    children.add(SizedBox(height: 10.0));
    children.add(RaisedButton(
      child: Text(buttonText),
      color: Theme.of(context).primaryColor,
      textColor: Theme.of(context).backgroundColor,
      onPressed: _submitForm,
    ));

    return children;
  }
}
