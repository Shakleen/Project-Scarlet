import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../entities/task_entity.dart';
import './task_form_page.dart';
import '../../scoped_model/task_model.dart';

class TaskDetails extends StatelessWidget {
  final TaskEntity inputTask;

  TaskDetails(this.inputTask);

  Widget _buildHeaderText(String header) {
    return Padding(
      child: Text(
        header,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      padding: EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
    );
  }

  Widget _buildContentText(String content) {
    return Padding(
      child: Text(
        content,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
        ),
      ),
      padding: EdgeInsets.only(right: 10.0, left: 10.0, top: 2.0, bottom: 5.0),
    );
  }

  Widget _buildListView(TaskEntity inputTask) {
    final DateTime dateTime = inputTask.getDueDate();
    final String dateTimeString = dateTime.day.toString() +
        '/' +
        dateTime.month.toString() +
        '/' +
        dateTime.year.toString() +
        " at " +
        dateTime.hour.toString() +
        ':' +
        dateTime.minute.toString();

    final String name = inputTask.getName();
    final String description = inputTask.getDescription();
    final String priority = TaskModel.priorityLevels[inputTask.getPriority()];
    final String location = inputTask.getLocation();

    return ListView(
          children: <Widget>[
            _buildHeaderText('Name'),
            _buildContentText(name),
            Divider(
              color: Colors.black,
            ),
            _buildHeaderText('Date/Time'),
            _buildContentText(dateTimeString),
            Divider(
              color: Colors.black,
            ),
            _buildHeaderText('Description'),
            _buildContentText(description == null ? 'None' : description),
            Divider(
              color: Colors.black,
            ),
            _buildHeaderText('Priority'),
            _buildContentText(priority),
            Divider(
              color: Colors.black,
            ),
            _buildHeaderText('Location'),
            _buildContentText(location == null ? 'Unspecified' : location),
            Divider(
              color: Colors.black,
            ),
          ],
        );
  }

  Widget _buildForm(BuildContext context, TaskEntity inputTask) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View task details'),
      ),
      // Display the task which currently exist
      body: Container(
        child: _buildListView(inputTask)
      ),

      // Floating action button for adding new tasks and goals
      floatingActionButton: _buildFloatingActionButton(context, inputTask),
    );
  }

  /// Method for building the floating action button. It generates a new
  /// form for creating a new task. The button passes in [addTask] to the
  /// form for adding the new task to the list of tasks.
  FloatingActionButton _buildFloatingActionButton(
      BuildContext context, TaskEntity task) {
    return FloatingActionButton(
      child: Icon(Icons.edit),
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskForm(task)),
        );
      },
    );
  }

  Widget _buildFutureTask() {
    return ScopedModelDescendant<TaskModel>(
      builder: (BuildContext context, Widget child, TaskModel model) {
        final Future<TaskEntity> task = model.getSelectedTask(inputTask);
        return FutureBuilder<TaskEntity>(
          future: task,
          builder: (
            BuildContext context,
            AsyncSnapshot<TaskEntity> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              return _buildForm(context, snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildFutureTask();
  }
}
