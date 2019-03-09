import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_card_title.dart';
import 'package:project_scarlet/widgets/strategy_widgets/information.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_form.dart';
import 'package:project_scarlet/presentation/standard_values.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final int tabType;
  final List<List> _title = [], _children = [];
  TextStyle _head, _sub;
  double _deviceWidth;

  TaskCard({Key key, this.task, this.tabType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);
    _head = Theme.of(context).textTheme.display1;
    _sub = Theme.of(context).textTheme.subtitle;
    _deviceWidth = MediaQuery.of(context).size.width;
    _populateList();

    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, style: BorderStyle.solid),
          ),
        ),
        child: ExpansionTile(
          title: TaskCardTitle(info: _title),
          children: List<Widget>.generate(_children.length, _generate),
          initiallyExpanded: false,
          trailing: Icon(
            priorityData[task.priority][1],
            color: priorityData[task.priority][2],
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
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

  Widget _generate(int index) {
    return Container(
      child: Information(
        key: Key('Task card title ${_children[index][0]}'),
        text: _children[index][0],
        textStyle: _children[index][1],
        icon: _children[index][2],
        iconColor: _children[index][3],
        width: _children[index][4],
      ),
      margin: const EdgeInsets.only(left: 15.0),
    );
  }

  void _populateList() {
    final double partial = _deviceWidth * 0.7, full = _deviceWidth * 0.85;
    final String dueDate = dateFormatter.format(task.dueDate);
    final String complete = dateFormatter.format(task.setDate);
    final String setDate = dateFormatter.format(task.setDate);
    final String difficulty = difficultyData[task.difficulty][0];

    _title.add([task.name, _head, null, null, partial]);
    _title.add([dueDate, _sub, Icons.schedule, Colors.black, partial]);

    if (tabType == 2)
      _title.add([complete, _sub, Icons.check_circle, Colors.green, partial]);

    if (task.description != null)
      _children.add(
          [task.description, _sub, Icons.description, Colors.indigo, full]);

    if (task.location != null)
      _children.add(
          [task.location, _sub, Icons.location_on, Colors.deepOrange, full]);

    _children.add([setDate, _sub, Icons.save, Colors.black, full]);
    _children.add([difficulty, _sub, Icons.adjust, Colors.indigo, full]);
  }
}
