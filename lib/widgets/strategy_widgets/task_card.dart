import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/presentation/standard_values.dart';
import 'package:project_scarlet/widgets/strategy_widgets/info_builder.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_card_title.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_form.dart';

/// A class for displaying task related information.
///
/// The name, set date and complete date (if not null) is displayed by default.
/// More information is revealed on tap.
class TaskCard extends StatefulWidget {
  final TaskEntity task;
  final int tabType;

  TaskCard({Key key, this.task, this.tabType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final List<List> _title = [], _children = [];
  final List<Widget> _childrenWidgets = [];
  TaskBloc taskBloc;
  TaskEntity _taskEntity;
  TextStyle _head, _sub;
  double _deviceWidth;

  @override
  void initState() {
    _taskEntity = widget.task;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    taskBloc = BlocProvider.of<TaskBloc>(context);
    _head = Theme.of(context).textTheme.display1;
    _sub = Theme.of(context).textTheme.subtitle;
    _deviceWidth = MediaQuery.of(context).size.width;
    if (_title.isEmpty) _populateTitleList();

    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.black, style: BorderStyle.solid),
          ),
        ),
        child: ExpansionTile(
          title: TaskCardTitle(info: _title),
          children: _childrenWidgets,
          initiallyExpanded: false,
          trailing: Icon(
            priorityData[_taskEntity.priority][1],
            color: priorityData[_taskEntity.priority][2],
          ),
          onExpansionChanged: _onExpanded,
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
      ),
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  TaskForm(
                      inputTask: _taskEntity,
                      addTask: taskBloc.addTask,
                      updateTask: taskBloc.updateTask)),
        );
      },
    );
  }

  void _populateTitleList() {
    final double partial = _deviceWidth * 0.7;
    final String dueDate = dateFormatter.format(_taskEntity.dueDate);
    final String complete = dateFormatter.format(_taskEntity.setDate);

    _title.add([_taskEntity.name, _head, null, null, partial]);
    _title.add([dueDate, _sub, Icons.schedule, Colors.black, partial]);

    if (widget.tabType == 2)
      _title.add([complete, _sub, Icons.check_circle, Colors.green, partial]);
  }

  void _onExpanded(bool value) {
    if (value == true && _childrenWidgets.isEmpty) {
      taskBloc.getTaskDetails(_taskEntity).then((TaskEntity returnedTask) {
        setState(() {
          _taskEntity = returnedTask;
          _populateChildrenList();
          _childrenWidgets.addAll(List.generate(_children.length, _generate));
        });
      });
    }
  }

  Widget _generate(int index) {
    return Container(
      child: InfoBuilder(
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

  void _populateChildrenList() {
    final double full = _deviceWidth * 0.85;
    final String setDate = dateFormatter.format(_taskEntity.setDate);
    final String difficulty = difficultyData[_taskEntity.difficulty][0];
    final String description = _taskEntity.description;
    final String location = _taskEntity.location;

    if (description != null)
      _children
          .add([description, _sub, Icons.description, Colors.indigo, full]);

    if (location != null)
      _children
          .add([location, _sub, Icons.location_on, Colors.deepOrange, full]);

    _children.add([setDate, _sub, Icons.save, Colors.black, full]);
    _children.add([difficulty, _sub, Icons.adjust, Colors.indigo, full]);
  }
}
