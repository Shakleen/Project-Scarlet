import 'package:flutter/material.dart';

import '../ui_elements/default_title.dart';
import '../ui_elements/default_date.dart';

import '../../pages/strategy_pages/task_form_page.dart';
import '../../entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity _task;
  final Function _removeTask;
  final Function _completeTask;
  final int _index;

  TaskCard(this._task, this._index, this._removeTask, this._completeTask);

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
      onPressed: () => _completeTask(_task),
    );
  }

  Column _buildTaskCard(BuildContext context) {
    return Column(
        children: <Widget>[
          // Contains a task
          ListTile(
            leading: _task.getCompleteDate() == null ? _buildIconButton() : null,
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
