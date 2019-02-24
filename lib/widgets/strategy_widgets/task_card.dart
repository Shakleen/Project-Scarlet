import 'package:flutter/material.dart';

import '../../pages/strategy_pages/task_details_page.dart';
import '../../entities/task_entity.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final int tabNumber;

  TaskCard(this.task, this.tabNumber);

  /// Method for building the entire widget.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildDecorations(),
      child: _buildTaskCard(context, task),
      padding: EdgeInsets.symmetric(vertical: 5.0),
    );
  }

  Column _buildTaskCard(BuildContext context, TaskEntity task) {
    return Column(
      children: <Widget>[
        // Contains a task
        ListTile(
          title: _buildTitle(task.getName()),
          subtitle: _buildTrailer(),
          enabled: true,
          onLongPress: () {
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

  Widget _buildInformationText(IconData icon, String text) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 20.0,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
          ),
          Text(text),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0),
    );
  }

  Widget _buildTrailer() {
    return Column(
      children: <Widget>[
        _buildInformationText(Icons.access_time, task.getDueDate().toString()),
        _buildInformationText(Icons.description, task.getDescription()),
        _buildInformationText(Icons.location_on, task.getLocation()),
      ],
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 26,
          fontFamily: 'Roboto',
          shadows: [
            Shadow(
              color: Colors.grey[300],
              offset: Offset(1.0, 1.0),
              blurRadius: 1.5,
            ),
          ],
        ),
      ),
    );
  }

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
}
