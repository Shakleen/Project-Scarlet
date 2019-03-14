import 'package:flutter/material.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_combo_box.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_date_picker.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_form_field.dart';

/// A class for inputting or changing already exsting tasks via a form.
class TaskForm extends StatefulWidget {
  final TaskEntity inputTask;
  final Future<bool> Function(TaskEntity) addTask, updateTask;
  final void Function(TaskEntity task, bool status) showSnackBar;

  TaskForm({
    Key key,
    @required this.inputTask,
    @required this.addTask,
    @required this.updateTask,
    this.showSnackBar,
  }) : super(key: key);

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
    final double deviceWidth = MediaQuery.of(context).size.width,
        targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95,
        targetPadding = deviceWidth - targetWidth;
    final String title =
    widget.inputTask == null ? 'Add new task' : 'Edit task details';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(title, style: Theme
              .of(context)
              .textTheme
              .title),
        ),
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: Form(
            autovalidate: true,
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: targetPadding / 2.0),
              children: _buildChildren(),
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    _formData[columnData[7][0]] =
        (widget.inputTask != null) ? widget.inputTask.setDate : DateTime.now();

    final TaskEntity task = fromMap(_formData);
    if (widget.inputTask == null)
      widget.addTask(task).then((bool status) {
        widget.showSnackBar(task, status);
        return status;
      });
    else
      widget.updateTask(task).then((bool status) {
        widget.showSnackBar(task, status);
        return status;
      });

    Navigator.pop(context);
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
        TaskComboBox(priorityData, _formData, columnData[3][0], priority),
        TaskComboBox(difficultyData, _formData, columnData[4][0], difficulty)
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
