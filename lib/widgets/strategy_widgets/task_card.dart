import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../pages/strategy_pages/task_form_page.dart';
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
    final double deviceWidth = MediaQuery.of(context).size.width * 0.8;
    return Column(
      children: <Widget>[
        // Contains a task
        ListTile(
          title: _buildInformationText(
              Icons.title, task.getName(), deviceWidth, 26.0, 0.0),
          subtitle: _buildTrailer(deviceWidth),
          enabled: true,
          onLongPress: () {
            if (tabNumber != 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskForm(task),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildTrailer(double deviceWidth) {
    return Column(
      children: <Widget>[
        _buildInformationText(Icons.access_time,
            _formatDateTime(task.getDueDate()), deviceWidth, 14.0, 20.0),
        _buildInformationText(
            Icons.description, task.getDescription(), deviceWidth, 14.0, 20.0),
        _buildInformationText(
            Icons.location_on, task.getLocation(), deviceWidth, 14.0, 20.0),
      ],
    );
  }

  Widget _buildInformationText(IconData icon, String text, double deviceWidth,
      double fontSize, double iconSize) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: iconSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
          ),
          Container(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
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
            width: deviceWidth,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0),
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

  String _formatDateTime(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat("EEEE, dd-MM-yyyy 'at' HH:mm:ss");
    final String formatted = dateFormat.format(dateTime);
    return formatted;
  }
}
