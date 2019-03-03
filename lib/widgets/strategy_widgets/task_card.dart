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
  _TaskCard createState() => _TaskCard();
}

class _TaskCard extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, style: BorderStyle.solid),
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
      Container(
        child: Text(
          widget.task.name,
          style: Theme.of(context)
              .textTheme
              .display1
              .copyWith(color: Colors.black),
          softWrap: true,
        ),
        alignment: Alignment.centerLeft,
      ),
      _buildInformationText(
        Icons.schedule,
        MainModel.dateFormatter.format(widget.task.dueDate),
        Colors.black,
        true,
      )
    ];

    if (widget.task.completeDate != null)
      childrenList.add(_buildInformationText(
        Icons.check_circle,
        MainModel.dateFormatter.format(widget.task.completeDate),
        Colors.green,
      ));

    return Column(children: childrenList);
  }

  Widget _buildChildren() {
    final List<Widget> childrenList = [];

    if (widget.task.description != null)
      childrenList.add(_buildInformationText(
          Icons.format_align_left, widget.task.description, Colors.indigo));

    if (widget.task.location != null)
      childrenList.add(_buildInformationText(
          Icons.location_on, widget.task.location, Colors.deepOrange));

    childrenList.add(_buildInformationText(Icons.save,
        MainModel.dateFormatter.format(widget.task.setDate), Colors.indigo));
    childrenList.add(_buildInformationText(Icons.blur_circular,
        TaskEntity.difficultyLevels[widget.task.difficulty][0], Colors.indigo));

    return Container(
      child: Column(children: childrenList),
      margin: EdgeInsets.only(left: 15.0),
    );
  }

  Widget _buildInformationText(IconData icon, String text, Color iconColor,
      [bool half = false]) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: Theme.of(context).textTheme.subtitle.fontSize,
            color: iconColor,
          ),
          Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)),
          Container(
            width: deviceWidth * (half ? 0.7 : 0.85),
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .subtitle
                  .copyWith(color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0),
    );
  }
}
