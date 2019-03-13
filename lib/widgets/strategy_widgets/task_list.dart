import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_database_bloc.dart';
import 'package:project_scarlet/bloc/task_list_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_dismissible.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_fab.dart';

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
  SnackBar _loadingSnackBar;
  TaskListBloc _taskListBloc;
  TaskDatabaseBloc _taskBloc;

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

    _controller = new ScrollController();

    _taskListBloc = TaskListBloc(
      tabType: widget.tabType,
      completeTask: _handleCompleteTask,
      removeTask: _handleRemoveTask,
      updateTask: _handleUpdateTask,
      addTask: _handleAddTask,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskBloc = BlocProvider.of<TaskDatabaseBloc>(context);

    return BlocProvider<TaskListBloc>(
      // The bloc that is to be available to the children of the widget
      bloc: _taskListBloc,

      // The widget of the bloc
      child: Scaffold(
        floatingActionButton: TaskFAB(),
        body: StreamBuilder<List<TaskEntity>>(
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
                      );
                    },
                  ),
                ),
              );
            } else if (snapshot.connectionState == ConnectionState.active)
              return Center(child: CircularProgressIndicator());

            return Container(height: 0.0, width: 0.0);
          },
        ),
      ),
    );
  }

  Widget _showSnackBar(String text, Color color) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      duration: Duration(seconds: 2),
      content: Text(text),
      backgroundColor: color,
    ));
  }

  void _handleAddTask(TaskEntity task, bool status) {
    if (status) {
      _showSnackBar('${task.name} scheduled!', Theme
          .of(context)
          .primaryColor);
      setState(() {});
    } else
      _showSnackBar('Couldn\'t add ${task.name}', Theme
          .of(context)
          .errorColor);
  }

  void _handleCompleteTask(TaskEntity task, bool status) {
    if (status) {
      _listToDisplay.remove(task);
      _showSnackBar('${task.name} completed!', Theme
          .of(context)
          .primaryColor);
      setState(() {});
    } else
      _showSnackBar(
          'Couldn\'t complete ${task.name}', Theme
          .of(context)
          .errorColor);
  }

  void _handleRemoveTask(TaskEntity task, bool status) {
    if (status) {
      _listToDisplay.remove(task);
      _showSnackBar('${task.name} removed!', Theme
          .of(context)
          .primaryColor);
      setState(() {});
    } else
      _showSnackBar(
          'Couldn\'t remove ${task.name}', Theme
          .of(context)
          .errorColor);
  }

  void _handleUpdateTask(TaskEntity task, bool status) {
    if (status) {
      _showSnackBar('${task.name} updated!', Theme
          .of(context)
          .primaryColor);
      setState(() {});
    } else
      _showSnackBar(
          'Couldn\'t update ${task.name}', Theme
          .of(context)
          .errorColor);
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
