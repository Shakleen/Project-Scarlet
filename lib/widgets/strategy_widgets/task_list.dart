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
/// stream in the [_taskBloc] which it gets via the [BlocProvider] class. If it has
/// data to display it builds the list otherwise a progress indicator is shown.
class _TaskListState extends State<TaskList> {
  final List<TaskEntity> _listToDisplay = [];
  ScrollController _controller;
  int len = 0;
  SnackBar _loadingSnackBar, _deletedSnackBar, _completedSnackBar;

  @override
  void initState() {
    _loadingSnackBar = SnackBar(
      duration: Duration(milliseconds: 500),
      content: Row(
        children: <Widget>[
          Text("Loading more, please wait"),
          CircularProgressIndicator(),
        ],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
    );

    _deletedSnackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Text('Task deleted successfully'),
      backgroundColor: Colors.red,
    );

    _completedSnackBar = SnackBar(
      duration: Duration(seconds: 2),
      content: Text('Task completed successfully'),
      backgroundColor: Colors.green,
    );

    _controller = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final TaskBloc _taskBloc = BlocProvider.of<TaskBloc>(context);

    return StreamBuilder<List<TaskEntity>>(
      stream: _taskBloc.getStream(widget.tabType),
      builder:
          (BuildContext context, AsyncSnapshot<List<TaskEntity>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) {
            if (_listToDisplay.isEmpty)
              _listToDisplay.addAll(snapshot.data);
            else if (_listToDisplay[len] != snapshot.data[0]) {
              len += snapshot.data.length;
              _listToDisplay.addAll(snapshot.data);
            }

            return NotificationListener<ScrollNotification>(
              onNotification: _handleScrollNotification,
              child: Scrollbar(
                child: ListView.builder(
                  controller: _controller,
                  itemCount: _listToDisplay.length,
                  itemBuilder: (BuildContext context, int index) {
                    return TaskDismissible(
                      key: Key(_listToDisplay[index].setDate.toString()),
                      task: _listToDisplay[index],
                      tabType: widget.tabType,
                      removeTaskFromList: _removeFromList,
                    );
                  },
                ),
              ),
            );
          }
          return Container(height: 0.0, width: 0.0);
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  void _removeFromList(TaskEntity task, bool type) {
    setState(() {
      _listToDisplay.remove(task);

      Scaffold.of(context).hideCurrentSnackBar();
      Scaffold.of(context).showSnackBar(
        type ? _deletedSnackBar : _completedSnackBar,
      );
    });
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      if (_controller.position.extentAfter == 0) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(_loadingSnackBar);
        setState(() {});
      }
    }
    return false;
  }
}
