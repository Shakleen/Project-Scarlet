import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../widgets/helper/ensure-visible.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

import '../../entities/task_entity.dart';
import '../../scoped_model/task_model.dart';

class TaskForm extends StatefulWidget {
  final TaskEntity inputTask;
  final int inputIndex;

  TaskForm(this.inputTask, this.inputIndex);

  @override
  _TaskForm createState() {
    return _TaskForm();
  }
}

class _TaskForm extends State<TaskForm> {
  final Map<String, dynamic> _formData = {
    'name': null,
    'dueDate': DateTime.now(),
    'description': null,
    'priority': 0,
    'location': null
  };
  final Map<int, String> _priorityLevels = {
    0: 'Low',
    1: 'Normal',
    2: 'Important',
    3: 'Urgent'
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priorityFocusNode = FocusNode();
  final _locationFocusNode = FocusNode();
  final TextStyle labelStyle =
      TextStyle(color: Colors.blueAccent, fontFamily: 'Roboto');

  /// Method for building a text field for name property.
  ///
  /// The method initializes itself as blank if it is for a new
  /// task, otherwise it displays the name of the [task] that is
  /// being updated.
  ///
  /// The condition for acceptance is that the name must be at least
  /// 5 and less than or equal to 100 characters.
  Widget _buildNameTextField(TaskEntity task) {
    return EnsureVisibleWhenFocused(
      focusNode: _nameFocusNode,
      child: TextFormField(
        focusNode: _nameFocusNode,
        decoration: InputDecoration(
          labelText: 'Task name',
          labelStyle: labelStyle,
        ),
        initialValue: task == null ? '' : task.getName(),
        validator: (String value) {
          if (value.length < 5) {
            return 'Name must be at least 5 characters!';
          } else if (value.length > 100) {
            return 'Name can be at most 200 characters!';
          }
        },
        onSaved: (String value) {
          _formData['name'] = value;
          value = "";
        },
      ),
    );
  }

  /// Method for building a date field for the due date property.
  ///
  /// The method initializes itself as the current date for a new
  /// task, otherwise it displays the due date of the [task] that is
  /// being updated.
  ///
  /// The condition for acceptance is that the due date can't be in
  /// the past.
  Widget _buildDueDateField(TaskEntity task) {
    final formats = {
      // InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
      InputType.both: DateFormat("dd/MM/yyyy hh:mm"),
      //2019-02-23 18:00:00.000
    };

    InputType inputType = InputType.both;

    return DateTimePickerFormField(
      inputType: inputType,
      format: formats[inputType],
      editable: true,
      decoration: InputDecoration(
        labelText: 'Date/Time',
        labelStyle: labelStyle,
        hasFloatingPlaceholder: false,
      ),
      initialDate: task == null ? DateTime.now() : task.getDueDate(),
      validator: (DateTime value) {
        if (value.compareTo(DateTime.now()) < 0) {
          return "Due date can't be in the past!";
        }
      },
      onSaved: (DateTime value) {
        _formData['dueDate'] = value;
      },
    );
  }

  /// Method for building a description field for the task description
  /// property.
  ///
  /// The method initializes itself as blank if it is for a new
  /// task, otherwise it displays the description of the [task] that is
  /// being updated.
  ///
  /// The condition for acceptance is that the description should be at max
  /// 200 characters.
  Widget _buildDescriptionTextField(TaskEntity task) {
    return EnsureVisibleWhenFocused(
      focusNode: _descriptionFocusNode,
      child: TextFormField(
        focusNode: _descriptionFocusNode,
        decoration: InputDecoration(
          labelText: 'Task description',
          labelStyle: labelStyle,
        ),
        initialValue: task == null ? '' : task.getDescription(),
        validator: (String value) {
          if (value.length > 200) {
            return "Description can't be above 200 character";
          }
        },
        onSaved: (String value) {
          if (value.length <= 0) {
            _formData['description'] = 'None';
          } else {
            _formData['description'] = value;
          }
        },
      ),
    );
  }

  Widget _buildPriorityField(TaskEntity task) {
    return EnsureVisibleWhenFocused(
      focusNode: _priorityFocusNode,
      child: TextFormField(
        focusNode: _priorityFocusNode,
        decoration: InputDecoration(labelText: 'Task Priority'),
        initialValue: task == null
            ? _priorityLevels[0]
            : _priorityLevels[task.getPriority()],
        validator: (String value) {
          if (value.length > 200) {
            return "Description can't be above 200 character";
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
      ),
    );
  }

  /// Method for building a location text field for the task location
  /// property.
  ///
  /// The method initializes itself as blank if it is for a new
  /// task, otherwise it displays the location of the [task] that is
  /// being updated.
  ///
  /// The condition for acceptance is that the location should be at max
  /// 200 characters.
  Widget _buildLocationTextField(TaskEntity task) {
    return EnsureVisibleWhenFocused(
      focusNode: _locationFocusNode,
      child: TextFormField(
        focusNode: _locationFocusNode,
        decoration: InputDecoration(
          labelText: 'Task location',
          labelStyle: labelStyle,
        ),
        initialValue: task == null ? '' : task.getLocation(),
        validator: (String value) {
          if (value.length > 200) {
            return 'Location can be at most 200 characters';
          }
        },
        onSaved: (String value) {
          if (value.length > 0) {
            _formData['location'] = value;
          } else {
            _formData['location'] = 'Unspecified';
          }
        },
      ),
    );
  }

  /// Method for building a button for submitting the form of task creation.
  ///
  /// The button calls the _submitForm when clicked!
  Widget _buildSubmitButton(TaskEntity inputTask, int inputIndex) {
    String buttonText = inputTask == null ? 'Add new task' : 'Update task';

    return ScopedModelDescendant<TaskModel>(
      builder: (BuildContext context, Widget child, TaskModel model) {
        return RaisedButton(
          child: Text(buttonText),
          color: Colors.blueAccent,
          textColor: Colors.white,
          onPressed: () {
            _submitForm(model.addTask, model.updateTask, inputTask, inputIndex);
          },
        );
      },
    );
  }

  /// This method creates and saves the task by using the [addTask] function
  /// passed into it.
  void _submitForm(Function addTask, Function updateTask, TaskEntity inputTask,
      int inputIndex) {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    // Add mode
    if (inputTask == null) {
      addTask(
        _formData['name'],
        _formData['dueDate'],
        _formData['description'],
        _formData['priority'],
        _formData['location'],
      );
    } else if (inputIndex != null) {
      updateTask(
        inputIndex,
        _formData['name'],
        _formData['dueDate'],
        _formData['description'],
        _formData['priority'],
        _formData['location'],
      );
    }

    Navigator.pop(context);
  }

  Widget _buildForm(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return Container(
      margin: EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: targetPadding / 2.0),
          children: <Widget>[
            _buildNameTextField(widget.inputTask),
            SizedBox(
              height: 10.0,
            ),
            _buildDueDateField(widget.inputTask),
            SizedBox(
              height: 10.0,
            ),
            _buildDescriptionTextField(widget.inputTask),
            SizedBox(
              height: 10.0,
            ),
            _buildLocationTextField(widget.inputTask),
            SizedBox(
              height: 10.0,
            ),
            _buildSubmitButton(widget.inputTask, widget.inputIndex),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeaderText(String header) {
  //   return Padding(
  //     child: Text(
  //       header,
  //       style: TextStyle(
  //         fontFamily: 'Roboto',
  //         fontWeight: FontWeight.w600,
  //         fontSize: 24,
  //       ),
  //     ),
  //     padding: EdgeInsets.symmetric(
  //       vertical: 5.0,
  //       horizontal: 10.0,
  //     ),
  //   );
  // }

  // Widget _buildContentText(String content) {
  //   return Padding(
  //     child: Text(
  //       content,
  //       style: TextStyle(
  //         fontFamily: 'Roboto',
  //         fontSize: 16,
  //       ),
  //     ),
  //     padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 2.0, bottom: 5.0),
  //   );
  // }

  // Widget _buildFormView() {
  //   return Container(
  //     child: ListView(
  //       children: <Widget>[
  //         _buildHeaderText('Name'),
  //         _buildContentText(widget.inputTask.getName()),
  //         Divider(color: Colors.black,),
  //         _buildHeaderText('Date/Time'),
  //         _buildContentText(widget.inputTask.getDueDate().toString()),
  //         Divider(color: Colors.black,),
  //         _buildHeaderText('Description'),
  //         _buildContentText(widget.inputTask.getDescription()),
  //         Divider(color: Colors.black,),
  //         _buildHeaderText('Priority'),
  //         _buildContentText(_priorityLevels[widget.inputTask.getPriority()]),
  //         Divider(color: Colors.black,),
  //         _buildHeaderText('Location'),
  //         _buildContentText(widget.inputTask.getLocation()),
  //         Divider(color: Colors.black,),
  //       ],
  //       // crossAxisAlignment: CrossAxisAlignment.start,
  //     ),
  //   );
  // }

  // /// Method for building the floating action button. It generates a new
  // /// form for creating a new task. The button passes in [addTask] to the
  // /// form for adding the new task to the list of tasks.
  // FloatingActionButton _buildFloatingActionButton(BuildContext context) {
  //   return FloatingActionButton(
  //     child: Icon(widget.editState ? Icons.cancel : Icons.edit),
  //     backgroundColor: Colors.red,
  //     onPressed: () {
  //       setState(() {
  //         widget.editState = true;
  //       });
  //     },
  //   );
  // }

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
}
