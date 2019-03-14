import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_bloc.dart';
import 'package:project_scarlet/bloc/task_database_bloc.dart';
import 'package:project_scarlet/bloc/task_list_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/presentation/standard_values.dart';
import 'package:project_scarlet/widgets/strategy_widgets/info_builder.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_form.dart';

/// A class for displaying task related information.
///
/// The name, set date and complete date (if not null) is displayed by default.
/// More information is revealed on tap.
class TaskCard extends StatefulWidget {
  TaskCard({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final List<List> _title = [], _children = [];
  TaskDatabaseBloc _taskDBMSBloc;
  TaskListBloc _taskListBloc;
  TaskBloc _taskBloc;

  @override
  Widget build(BuildContext context) {
    _taskListBloc = BlocProvider.of<TaskListBloc>(context);
    _taskDBMSBloc = BlocProvider.of<TaskDatabaseBloc>(context);
    _taskBloc = BlocProvider.of<TaskBloc>(context);
    if (_title.isEmpty) _populateTitleList();

    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, style: BorderStyle.solid),
          ),
        ),
        child: ExpansionTile(
          title: Column(children: _title.map(_buildInfo).toList()),
          children: _children.map(_buildInfo).toList(),
          initiallyExpanded: false,
          trailing: Icon(
            priorityData[_taskBloc.task.priority][1],
            color: priorityData[_taskBloc.task.priority][2],
          ),
          onExpansionChanged: _onExpanded,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
      ),
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => TaskForm(
                inputTask: _taskBloc.task,
                addTask: _taskDBMSBloc.addTask,
                updateTask: _taskDBMSBloc.updateTask,
                showSnackBar: _taskListBloc.updateTask,
                  )),
        );
      },
    );
  }

  InfoBuilder _buildInfo(List l) =>
      InfoBuilder(
          key: Key('${l[0]}'),
          text: l[0],
          icon: l[1],
          iconColor: l[2],
          type: l[3]);

  void _populateTitleList() {
    final String dueDate = dateFormatter.format(_taskBloc.task.dueDate);
    _title.add([_taskBloc.task.name, null, null, null]);
    _title.add([dueDate, Icons.schedule, Colors.black, true]);
  }

  void _onExpanded(bool value) {
    if (value == true && _children.isEmpty) {
      _taskBloc.getTaskDetails().then((bool value) {
        if (value)
          setState(() {
            _populateChildrenList();
          });
      });
    }
  }

  void _populateChildrenList() {
    final String setDate = dateFormatter.format(_taskBloc.task.setDate);
    final String difficulty = difficultyData[_taskBloc.task.difficulty][0];
    final String description = _taskBloc.task.description;
    final String location = _taskBloc.task.location;

    if (description != null)
      _children.add([description, Icons.description, Colors.indigo, false]);

    if (location != null)
      _children.add([location, Icons.location_on, Colors.deepOrange, false]);

    _children.add([setDate, Icons.save, Colors.black, false]);
    _children.add([difficulty, Icons.adjust, Colors.indigo, false]);
  }
}
