import 'package:flutter/material.dart';

import '../../pages/strategy_pages/task_form_page.dart';
import '../../entities/task_entity.dart';
import '../../scoped_model/main_model.dart';

class TaskCard extends StatefulWidget {
  final TaskEntity task;
  final int tabNumber;
  final Function addTask, updateTask;

  TaskCard(this.task, this.tabNumber, this.addTask, this.updateTask);

  @override
  _TaskCard createState() {
    return _TaskCard();
  }
}

class _TaskCard extends State<TaskCard> {
  double deviceWidth;
  final double titleFontSize = 24.0,
      contentFontSize = 12.0,
      contentIconSize = 15.0;

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width * 0.7;
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.black,
              style: BorderStyle.solid,
            ),
          ),
        ),
        child: ExpansionTile(
          title: _buildTitle(),
          children: <Widget>[_buildChildren()],
          initiallyExpanded: false,
          trailing: Icon(
            TaskEntity.priorityLevels[widget.task.priority][1],
            color: TaskEntity.priorityLevels[widget.task.priority][2],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.0),
      ),
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TaskForm(widget.task, widget.addTask, widget.updateTask)),
        );
      },
    );
  }

  Widget _buildTitle() {
    final List<Widget> childrenList = [
      _buildInformationText(
        null,
        widget.task.name,
        titleFontSize,
        0.0,
        Colors.white,
        Colors.black,
      ),
      _buildInformationText(
        Icons.schedule,
        MainModel.dateFormatter.format(widget.task.dueDate),
        contentFontSize,
        contentIconSize,
        Colors.black,
        Colors.black,
      )
    ];

    if (widget.task.completeDate != null) {
      childrenList.add(_buildInformationText(
        Icons.check_circle,
        MainModel.dateFormatter.format(widget.task.completeDate),
        contentFontSize,
        contentIconSize,
        Colors.green,
        Colors.black,
      ));
    }

    return Container(
      child: Column(
        children: childrenList,
      ),
    );
  }

  Widget _buildChildren() {
    final List<Widget> childrenList = [];

    if (widget.task.description != null) {
      childrenList.add(_buildInformationText(
        Icons.format_align_left,
        widget.task.description,
        contentFontSize,
        contentIconSize,
        Colors.indigo,
        Colors.black,
      ));
    }

    if (widget.task.location != null) {
      childrenList.add(_buildInformationText(
        Icons.location_on,
        widget.task.location,
        contentFontSize,
        contentIconSize,
        Colors.deepOrange,
        Colors.black,
      ));
    }

    childrenList.add(_buildInformationText(
      Icons.save,
      MainModel.dateFormatter.format(widget.task.setDate),
      contentFontSize,
      contentIconSize,
      Colors.indigo,
      Colors.black,
    ));
    childrenList.add(_buildInformationText(
      Icons.blur_circular,
      TaskEntity.difficultyLevels[widget.task.difficulty][0],
      contentFontSize,
      contentIconSize,
      Colors.indigo,
      Colors.black,
    ));

    return Container(
      child: Column(
        children: childrenList,
      ),
      margin: EdgeInsets.only(left: 15.0),
    );
  }

  Widget _buildInformationText(IconData icon, String text, double fontSize,
      double iconSize, Color iconColor, Color textColor) {
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
            width: deviceWidth,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontFamily: 'Roboto',
              ),
            ),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0),
    );
  }
}
