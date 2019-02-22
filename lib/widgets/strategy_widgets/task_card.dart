import 'package:flutter/material.dart';

import '../ui_elements/default_title.dart';
import '../ui_elements/default_date.dart';

import '../../pages/strategy_pages/task_details_page.dart';
import '../../entities/task_entity.dart';
import '../../controller/task_database.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final int tabNumber;

  TaskCard(this.task, this.tabNumber);

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

  Column _buildTaskCard(BuildContext context) {
    return Column(
      children: <Widget>[
        // Contains a task
        ListTile(
          // leading: task.getCompleteDate() == null ? _buildIconButton() : null,
          title: DefaultTitle(task.getName()),
          trailing: DefaultDate(task.getDueDate(), tabNumber),
          enabled: true,
          onLongPress: () {
            TaskDatabase.taskDatabase.getTask(task.getID());
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetails(task),
              ),
            );
          },
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
