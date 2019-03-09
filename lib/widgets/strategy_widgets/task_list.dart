import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_dismissible.dart';

/// A class for showing the tasks stored in the database in the form of a list.
///
/// The widget takes a [tabType] parameter which defines what type of task to display.
/// [tabType] 0 means upcoming, 1 means overdue and 2 means completed.
class TaskList extends StatefulWidget {
  final int tabType;

  TaskList({Key key, @required this.tabType}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskListState();
}

/// State class for [TaskList].
///
/// This class utilizes a [StreamBuilder] to get the list of tasks as a stream and
/// then displays them onto the screen. It uses [widget.tabType] to use the proper
/// stream in the [taskBloc] which it gets via the [BlocProvider] class. If it has
/// data to display it builds the list otherwise a progress indicator is shown.
class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    final TaskBloc taskBloc = BlocProvider.of<TaskBloc>(context);

    return StreamBuilder<List<TaskEntity>>(
      stream: taskBloc.getStream(widget.tabType),
      builder:
          (BuildContext context, AsyncSnapshot<List<TaskEntity>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0)
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return TaskDismissible(
                  key: Key(snapshot.data[index].setDate.toString()),
                  task: snapshot.data[index],
                  tabType: widget.tabType,
                );
              },
            );
          return Container(height: 0.0, width: 0.0);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
