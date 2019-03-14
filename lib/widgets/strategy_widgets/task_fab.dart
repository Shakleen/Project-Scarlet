import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_database_bloc.dart';
import 'package:project_scarlet/controller/task_manager.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_form.dart';

/// A class for creating a Floating action button for the strategy page.
///
/// It calls the [_taskBloc.addTask] method when tapped. It gets the method
/// through the bloc provider.
class TaskFAB extends StatefulWidget {
  final Color shrinkColor, expandedColor;

  TaskFAB({
    Key key,
    @required this.shrinkColor,
    @required this.expandedColor,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TaskFABState();
}

class _TaskFABState extends State<TaskFAB> with SingleTickerProviderStateMixin {
  TaskDatabaseBloc _taskBloc;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon, _translateButton;
  double _fabHeight;
  bool _isOpened;

  @override
  void initState() {
    _fabHeight = 56.0;
    _isOpened = false;
    _animationController =
    AnimationController(vsync: this, duration: Duration(milliseconds: 500))
      ..addListener(() {
        setState(() {});
      });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: widget.shrinkColor,
      end: widget.expandedColor,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(0.00, 1.00, curve: Curves.linear),
    ));
    _translateButton =
        Tween<double>(begin: _fabHeight, end: -14.0).animate(CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.0, 0.75, curve: Curves.easeOut),
        ));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _taskBloc = BlocProvider.of<TaskDatabaseBloc>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Transform(
          transform:
          Matrix4.translationValues(0.0, _translateButton.value * 2.0, 0.0),
          child: _buildUndoButton(),
        ),
        Transform(
          transform:
          Matrix4.translationValues(0.0, _translateButton.value, 0.0),
          child: _buildAddButton(),
        ),
        _buildMenuButton(),
      ],
    );
  }

  Widget _buildAddButton() =>
      Container(
          child: FloatingActionButton(
            heroTag: "Add FAB",
            backgroundColor: widget.shrinkColor,
            tooltip: "Add new task",
            child: Icon(Icons.add),
            onPressed: _addOperation,
          ));

  Widget _buildUndoButton() =>
      Container(
        child: FloatingActionButton(
          heroTag: "Undo FAB",
          backgroundColor: widget.shrinkColor,
          tooltip: "Revert remove or complete",
          child: Icon(Icons.undo),
          onPressed: _handleUndoOperation,
        ),
      );

  Widget _buildMenuButton() =>
      Container(
        child: FloatingActionButton(
          heroTag: "Menu FAB",
          backgroundColor: _animateColor.value,
          tooltip: _isOpened ? "Hide actions" : "Show actions",
          child: AnimatedIcon(
              icon: AnimatedIcons.menu_close, progress: _animateIcon),
          onPressed: _animate,
        ),
      );

  void _animate() {
    _isOpened = !_isOpened;
    _isOpened ? _animationController.forward() : _animationController.reverse();
  }

  void _addOperation() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                TaskForm(
                  inputTask: null,
                  addTask: _taskBloc.addTask,
                  updateTask: _taskBloc.updateTask,
                  showSnackBar: _handleAddTask,
                )));
  }

  void _handleUndoOperation() {
    if (TaskManager.taskManager.nonEmpty) {
      TaskManager.taskManager.undoOperation().then((bool status) {
        status
            ? _showSnackBar('Operation reverted', widget.shrinkColor)
            : _showSnackBar('Operation undo failed', widget.expandedColor);

        return status;
      });
    }
  }

  void _handleAddTask(TaskEntity task, bool status) {
    status
        ? _showSnackBar('${task.name} scheduled!', widget.shrinkColor)
        : _showSnackBar(
        'Couldn\'t add ${task.name}', widget.expandedColor);
  }

  void _showSnackBar(String text, Color color) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(text),
      duration: Duration(seconds: 2),
      backgroundColor: color,
    ));
  }
}
