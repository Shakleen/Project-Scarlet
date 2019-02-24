import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../pages/strategy_pages/task_form_page.dart';
import '../../entities/task_entity.dart';
import '../../scoped_model/task_model.dart';

class TaskCard extends StatefulWidget {
  final TaskEntity task;
  final int tabNumber;

  TaskCard(this.task, this.tabNumber);

  @override
  _TaskCard createState() {
    // TODO: implement createState
    return _TaskCard();
  }
}

class _TaskCard extends State<TaskCard> {
  IconData infoIcon;
  bool moreInfo;
  Color infoIconColor;
  Color backgroundColor;

  @override
  void initState() {
    moreInfo = false;
    infoIcon = Icons.expand_more;
    infoIconColor = Colors.black;
    backgroundColor = Colors.white;
    super.initState();
  }

  void _setState() {
    setState(() {
      moreInfo = !moreInfo;
      infoIcon = moreInfo ? Icons.expand_less : Icons.expand_more;
      infoIconColor = moreInfo ? Colors.blue : Colors.black;
      backgroundColor =moreInfo ? Colors.lightBlue[50] : Colors.white;
    });
  }

  /// Method for building the entire widget.
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildDecorations(),
      child: _buildTaskCard(context),
      padding: EdgeInsets.symmetric(vertical: 5.0),
    );
  }

  Column _buildTaskCard(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width * 0.6;
    final IconData priorityIcon =
        TaskModel.priorityLevels[widget.task.getPriority()][1];
    final Color priorityColor =
        TaskModel.priorityLevels[widget.task.getPriority()][2];

    return Column(
      children: <Widget>[
        // Contains a task
        ListTile(
          title: _buildInformationText(
            priorityIcon,
            widget.task.getName(),
            deviceWidth,
            26.0,
            25.0,
            priorityColor,
            Colors.black,
          ),
          subtitle: _buildTrailer(deviceWidth),
          trailing: IconButton(
            icon: Icon(infoIcon, size: 25,),
            color: infoIconColor,
            onPressed: () {
              _setState();
            },
          ),
          enabled: true,
          onLongPress: () {
            if (widget.tabNumber != 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskForm(widget.task),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildTrailer(double deviceWidth) {
    final String description = widget.task.getDescription();
    final String location = widget.task.getLocation();
    final List<Widget> childrenList = [];

    // Adding duedate
    childrenList.add(_buildInformationText(
      Icons.access_time,
      _formatDateTime(widget.task.getDueDate()),
      deviceWidth,
      14.0,
      20.0,
      Colors.black,
      Colors.black,
    ));

    if (moreInfo) {
      if (description != null && description != 'null') {
      childrenList.add(_buildInformationText(
        Icons.format_align_left,
        description,
        deviceWidth,
        14.0,
        20.0,
        Colors.indigo,
        Colors.black,
      ));
    }

    if (location != null && location != 'null') {
      childrenList.add(_buildInformationText(
        Icons.location_on,
        location,
        deviceWidth,
        14.0,
        20.0,
        Colors.deepOrange,
        Colors.black,
      ));
    }
    }

    return Column(
      children: childrenList,
    );
  }

  Widget _buildInformationText(IconData icon, String text, double deviceWidth,
      double fontSize, double iconSize, Color iconColor, Color textColor) {
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: iconSize,
            color: iconColor,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 2.0),
          ),
          Container(
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
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
      color: backgroundColor,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat("EEEE, dd/MM/yyyy 'at' hh:mm a");
    final String formatted = dateFormat.format(dateTime);
    return formatted;
  }
}
