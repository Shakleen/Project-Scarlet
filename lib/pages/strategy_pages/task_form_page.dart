import 'package:flutter/material.dart';

import '../../widgets/helper/ensure-visible.dart';
import 'package:scoped_model/scoped_model.dart';
import '../../widgets/ui_elements/combo_box.dart';

import '../../entities/task_entity.dart';
import '../../scoped_model/task_model.dart';

class TaskForm extends StatefulWidget {
  final TaskEntity inputTask;

  TaskForm(this.inputTask);

  @override
  _TaskForm createState() {
    return _TaskForm();
  }
}

class _TaskForm extends State<TaskForm> {
  final Map<String, dynamic> _formData = TaskEntity.taskFormData;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final TextStyle labelStyle = TextStyle(
    color: Colors.blueAccent,
    fontFamily: 'Roboto',
  );
  ComboBox comboBoxPriority, comboBoxDifficulty;
  DateTime dateTime;

  _TaskForm() {
    comboBoxPriority = null;
    comboBoxDifficulty = null;
    dateTime = null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Material(
        child: Scaffold(
          appBar: AppBar(
            title: Text('Edit task details'),
          ),
          body: _buildForm(context),
        ),
      ),
    );
  }

  void _selectDateTime(
      BuildContext context, DateTime initDate, TimeOfDay initTime) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: initTime,
      );

      if (pickedTime != null) {
        setState(() {
          dateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  /// Method for building a date field for the due date property.
  ///
  /// The method initializes itself as the current date for a new
  /// task, otherwise it displays the due date of the [task] that is
  /// being updated.
  ///
  /// The condition for acceptance is that the due date can't be in
  /// the past.
  Widget _buildDueDateField(TaskEntity task, BuildContext context) {
    if (dateTime == null) {
      dateTime =
          widget.inputTask == null ? DateTime.now() : widget.inputTask.dueDate;
    }

    return Container(
      child: Column(
        children: <Widget>[
          Text(
            'Date/Time',
            style: labelStyle,
          ),
          SizedBox(height: 5.0),
          Text(
            TaskModel.dateFormatter.format(dateTime),
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
            ),
          ),
          SizedBox(height: 5.0),
          RaisedButton(
            onPressed: () {
              return _selectDateTime(
                context,
                dateTime,
                TimeOfDay(
                  hour: dateTime.hour,
                  minute: dateTime.minute,
                ),
              );
            },
            child: Text(
              'Pick Date/Time',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.blue,
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }

  /// Method for building a priority field for the task priority
  /// property.
  ///
  /// The method initializes itself as low if it is for a new
  /// task, otherwise it displays the priority of the [task] that is
  /// being updated.
  Widget _buildPriorityField(TaskEntity task, int form) {
    if (form == 1) {
      comboBoxPriority =
          task == null ? ComboBox(form) : ComboBox(form, task.priority);
    } else {
      comboBoxDifficulty =
          task == null ? ComboBox(form) : ComboBox(form, task.difficulty);
    }
    final String labelText = form == 1 ? "Priority" : "Difficulty";

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            labelText,
            style: labelStyle,
          ),
          form == 1 ? comboBoxPriority : comboBoxDifficulty,
        ],
      ),
      padding: EdgeInsets.only(top: 10.0, right: 10.0),
    );
  }

  /// Method for building a button for submitting the form of task creation.
  ///
  /// The button calls the _submitForm when clicked!
  Widget _buildSubmitButton(
      TaskEntity inputTask, Function addTask, Function updateTask) {
    String buttonText = inputTask == null ? 'Add new task' : 'Update task';

    return RaisedButton(
      child: Text(buttonText),
      color: Colors.blueAccent,
      textColor: Colors.white,
      onPressed: () {
        _submitForm(addTask, updateTask, inputTask);
      },
    );
  }

  /// This method creates and saves the task by using the [addTask] function
  /// passed into it.
  void _submitForm(
      Function addTask, Function updateTask, TaskEntity inputTask) {
    if (!_formKey.currentState.validate() || dateTime.compareTo(DateTime.now()) < 0) {
      return;
    } 

    _formKey.currentState.save();

    if (widget.inputTask != null)
      _formData[TaskEntity.columnNames[7][0]] = widget.inputTask.setDate;

    _formData[TaskEntity.columnNames[1][0]] = dateTime;
    _formData[TaskEntity.columnNames[3][0]] = comboBoxPriority.choice;
    _formData[TaskEntity.columnNames[4][0]] = comboBoxDifficulty.choice;

    inputTask == null
        ? addTask(TaskEntity.fromMap(_formData))
        : updateTask(TaskEntity.fromMap(_formData));

    Navigator.pop(context);
  }

  Widget _buildForm(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return ScopedModelDescendant<TaskModel>(
        builder: (BuildContext context, Widget child, TaskModel model) {
      return Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          autovalidate: true,
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2.0),
            children: <Widget>[
              _buildFormField(
                focusNode: _nameFocusNode,
                initialValue:
                    widget.inputTask?.name == null ? '' : widget.inputTask.name,
                labelText: TaskEntity.columnNames[0][0],
                textInputType: TextInputType.text,
                maxLength: 50,
              ),
              _buildFormField(
                focusNode: _descriptionFocusNode,
                initialValue: widget.inputTask?.description == null
                    ? ''
                    : widget.inputTask.description,
                labelText: TaskEntity.columnNames[2][0],
                textInputType: TextInputType.text,
                maxLength: 150,
              ),
              _buildFormField(
                focusNode: _locationFocusNode,
                initialValue: widget.inputTask?.location == null
                    ? ''
                    : widget.inputTask.location,
                labelText: TaskEntity.columnNames[5][0],
                textInputType: TextInputType.text,
                maxLength: 100,
              ),
              _buildDueDateField(widget.inputTask, context),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: <Widget>[
                  _buildPriorityField(widget.inputTask, 1),
                  _buildPriorityField(widget.inputTask, 2),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton(
                  widget.inputTask, model.addTask, model.updateTask),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFormField({
    FocusNode focusNode,
    String labelText,
    String initialValue,
    TextInputType textInputType,
    int maxLength,
  }) {
    return Container(
      child: EnsureVisibleWhenFocused(
        focusNode: focusNode,
        child: TextFormField(
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: labelStyle,
          ),
          initialValue: initialValue,
          validator: (String value) {
            if (value.contains("'")) {
              return "Can not contain ' character";
            }
          },
          onSaved: (String value) {
            _formData[labelText] = value.length > 0 ? value : null;
          },
          maxLength: maxLength,
          maxLengthEnforced: true,
          keyboardType: textInputType,
        ),
      ),
    );
  }

  /// Method for building the entire widget.

}
