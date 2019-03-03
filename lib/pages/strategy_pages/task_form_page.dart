import 'package:flutter/material.dart';
import '../../widgets/ui_elements/combo_box.dart';
import '../../entities/task_entity.dart';
import '../../widgets/strategy_widgets/task_form_field.dart';
import '../../widgets/strategy_widgets/task_date_picker.dart';

class TaskForm extends StatefulWidget {
  final TaskEntity inputTask;
  final Function addTask, updateTask;

  TaskForm(this.inputTask, this.addTask, this.updateTask);

  @override
  _TaskForm createState() => _TaskForm();
}

class _TaskForm extends State<TaskForm> {
  final Map<String, dynamic> _formData = TaskEntity.taskFormData;
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
      child: Material(
        child: Scaffold(
          appBar: AppBar(title: Text('Edit task details')),
          body: _buildForm(context),
        ),
      ),
    );
  }

  /// This method creates and saves the task by using the [addTask] function
  /// passed into it.
  void _submitForm() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    _formData[TaskEntity.columnNames[7][0]] =
        (widget.inputTask != null) ? widget.inputTask.setDate : DateTime.now();

    final TaskEntity task = TaskEntity.fromMap(_formData);
    widget.inputTask == null ? widget.addTask(task) : widget.updateTask(task);

    Navigator.pop(context);
  }

  Widget _buildForm(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

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
    final String name =
        widget.inputTask?.name == null ? '' : widget.inputTask.name;
    final String description = widget.inputTask?.description == null
        ? ''
        : widget.inputTask.description;
    final String location =
        widget.inputTask?.location == null ? '' : widget.inputTask.location;
    final Map<String, List<dynamic>> textFieldParams = {
      'focusNode': [_nameFocusNode, _descriptionFocusNode, _locationFocusNode],
      'nextFocusNode': [_descriptionFocusNode, _locationFocusNode, null],
      'initialValue': [name, description, location],
      'label': [0, 2, 5],
      'fieldHint': ['E.g. Swimming', 'E.g. For 1 hour.', 'E.g. Swimming pool.'],
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
      ));
    children.add(SizedBox(height: 10.0));
    children.add(TaskDatePicker(_formData, TaskEntity.columnNames[1][0]));
    children.add(SizedBox(height: 10.0));
    children.add(Row(
      children: <Widget>[
        ComboBox(
          TaskEntity.priorityLevels,
          _formData,
          TaskEntity.columnNames[3][0],
          widget.inputTask == null ? 0 : widget.inputTask.priority,
        ),
        ComboBox(
          TaskEntity.difficultyLevels,
          _formData,
          TaskEntity.columnNames[4][0],
          widget.inputTask == null ? 0 : widget.inputTask.difficulty,
        )
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ));
    children.add(SizedBox(height: 10.0));
    children.add(RaisedButton(
      child: Text(widget.inputTask == null ? 'Add new task' : 'Update task'),
      color: Colors.blueAccent,
      textColor: Colors.white,
      onPressed: _submitForm,
    ));

    return children;
  }
}
