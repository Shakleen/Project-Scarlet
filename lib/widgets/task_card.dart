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
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 1.5),
          blurRadius: 1.0,
          spreadRadius: .5,
        ),
      ],
      color: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildDecorations(),
      child: Column(
        children: <Widget>[
          // Contains a task
          ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.done,
                size: 30,
                color: Colors.green,
              ),
              color: Colors.blueAccent,
              onPressed: () => removeTask(_index),
            ),
            title: DefaultTitle(_task.getName()),
            trailing: DefaultDate(_task.getDueDate()),
            enabled: true,
            onLongPress: () {
              print(_task.getDueDate());
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskForm(_task, _index)),
              );
            },
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 5.0),
    );
  }
}
