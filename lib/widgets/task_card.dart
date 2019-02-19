import 'package:flutter/material.dart';

import './ui_elements/default_title.dart';
import './ui_elements/default_date.dart';

import '../pages/task_form_page.dart';
import '../entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity _task;
  final Function removeTask;
  final int _index;

  TaskCard(this._task, this._index, this.removeTask);

  BoxDecoration _buildDecorations() {
    return BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.black,
          style: BorderStyle.solid,
        ),
      ),
      color: Colors.white,
    );
  }

  IconButton _buildIconButton() {
    return IconButton(
      icon: Icon(
        Icons.done,
        size: 30,
        color: Colors.green,
      ),
      color: Colors.blueAccent,
      onPressed: () => removeTask(_index),
    );
  }

  Column _buildTaskCard(BuildContext context) {
    return Column(
        children: <Widget>[
          // Contains a task
          ListTile(
            leading: _buildIconButton(),
            title: DefaultTitle(_task.getName()),
            trailing: DefaultDate(_task.getDueDate()),
            enabled: true,
            onLongPress: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TaskForm(_task, _index)),
                ),
          ),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildDecorations(),
      child: _buildTaskCard(context),
      padding: EdgeInsets.symmetric(vertical: 5.0),
    );
  }
}
