import 'package:flutter/material.dart';

import '../../entities/task_entity.dart';
import './task_form_page.dart';
import '../../scoped_model/task_model.dart';

/// A stateless widget class for showing class related information
/// in detail.
class TaskDetails extends StatelessWidget {
  final TaskEntity taskEntity;

  TaskDetails(this.taskEntity);

  /// Method for building the entire widget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View task details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskForm(taskEntity)),
              );
            },
          ),
        ],
      ),
      // Display the task which currently exist
      body: _buildListView(taskEntity),
    );
  }

  /// Method for building the list view.
  /// 
  /// Each list entry is a specific information about the task.
  Widget _buildListView(TaskEntity taskEntity) {
    final DateTime dateTime = taskEntity.getDueDate();
    final String dateTimeString = dateTime.day.toString() +
        '/' +
        dateTime.month.toString() +
        '/' +
        dateTime.year.toString() +
        " at " +
        dateTime.hour.toString() +
        ':' +
        dateTime.minute.toString();

    final String name = taskEntity.getName();
    final String description = taskEntity.getDescription();
    final String priority = TaskModel.priorityLevels[taskEntity.getPriority()];
    final String location = taskEntity.getLocation();

    return ListView(
      children: <Widget>[
        _buildHeaderText('Name'),
        _buildContentText(name),
        _buildDivider(),
        _buildHeaderText('Date/Time'),
        _buildContentText(dateTimeString),
        _buildDivider(),
        _buildHeaderText('Description'),
        _buildContentText(description == null ? 'None' : description),
        _buildDivider(),
        _buildHeaderText('Priority'),
        _buildContentText(priority),
        _buildDivider(),
        _buildHeaderText('Location'),
        _buildContentText(location == null ? 'Unspecified' : location),
        _buildDivider(),
      ],
    );
  }

  /// Method for building the information headers.
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

  /// Method for building the information contents.
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

  /// Method for building a seperator for seperating the information.
  Divider _buildDivider() {
    return Divider(
      color: Colors.black,
    );
  }
}
