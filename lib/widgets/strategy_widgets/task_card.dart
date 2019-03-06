import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/strategy/bloc_provider.dart';
import 'package:project_scarlet/bloc/strategy/task_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/pages/strategy_pages/task_form_page.dart';
import 'package:project_scarlet/presentation/standard_values.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final int tabType;

  TaskCard({this.task, this.tabType});

  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, style: BorderStyle.solid),
          ),
        ),
        child: ExpansionTile(
          title: _buildTitle(context),
          children: <Widget>[_buildChildren(context)],
          initiallyExpanded: false,
          trailing: Icon(
            priorityData[task.priority][1],
            color: priorityData[task.priority][2],
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.0),
      ),
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TaskForm(task, taskBloc.addTask, taskBloc.updateTask)),
        );
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    final List<Widget> childrenList = [
      Container(
        child: Text(
          task.name,
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
        StandardValues.dateFormatter.format(task.dueDate),
        Colors.black,
        context,
        half: true,
      )
    ];

    if (task.completeDate != null)
      childrenList.add(_buildInformationText(
        Icons.check_circle,
        StandardValues.dateFormatter.format(task.completeDate),
        Colors.green,
        context,
      ));

    return Column(children: childrenList);
  }

  Widget _buildChildren(BuildContext context) {
    final List<Widget> childrenList = [];

    if (task.description != null)
      childrenList.add(_buildInformationText(
          Icons.format_align_left, task.description, Colors.indigo, context));

    if (task.location != null)
      childrenList.add(_buildInformationText(
          Icons.location_on, task.location, Colors.deepOrange, context));

    childrenList.add(_buildInformationText(Icons.save,
        StandardValues.dateFormatter.format(task.setDate), Colors.indigo, context));
    childrenList.add(_buildInformationText(Icons.blur_circular,
        difficultyData[task.difficulty][0], Colors.indigo, context));

    return Container(
      child: Column(children: childrenList),
      margin: EdgeInsets.only(left: 15.0),
    );
  }

  Widget _buildInformationText(
      IconData icon, String text, Color iconColor, BuildContext context,
      {bool half = false}) {
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
