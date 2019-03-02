import 'package:flutter/material.dart';

import '../../entities/task_entity.dart';
import './task_card.dart';
import '../../pages/strategy_pages/task_form_page.dart';

/// [TaskList] class is resposible for displaying the list of tasks
/// in a specific tab which is a stateful class.
///
/// The types of tab are upcoming, overdue and completed. The type of
/// tab is represented by [tabType]. All the function variables
/// [getTaskList], [removeTask], [completeTask], [addTask], [updateTask]
/// are for interacting with Task database.
class TaskList extends StatefulWidget {
  final int tabType;
  final Function getTaskList, removeTask, completeTask, addTask, updateTask;

  TaskList(
    this.tabType,
    this.getTaskList,
    this.addTask,
    this.removeTask,
    this.completeTask,
    this.updateTask,
  );

  @override
  _TaskListState createState() {
    return _TaskListState();
  }
}

/// [_TaskListState] stateless class is redrawn based on the change of its contents
/// which is the [_taskList].
/// 
/// It displays the tasks in [_taskList] and also displays snack bars [_deleteSnackBar] 
/// upon the delete and [_completeSnackBar] on completion of a task to revert changes. 
/// These snack bars are built by the function [_buildSnackBar].
class _TaskListState extends State<TaskList> {
  List<TaskEntity> _taskList = [];
  SnackBar _deleteSnackBar, _completeSnackBar;
  TaskEntity _swipedTask;

  @override
  void initState() {
    _deleteSnackBar = _buildSnackBar(true);
    _completeSnackBar = _buildSnackBar(false);
    _swipedTask = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the task which currently exist
      body: FutureBuilder<List<TaskEntity>>(
      future: widget.getTaskList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<TaskEntity>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          _taskList = snapshot.hasData ? snapshot.data : [];

          if (snapshot.hasError) {
            // TODO: Handle Error code
          }

          return _buildListView();
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),

      // Floating action button for adding new tasks and goals
      floatingActionButton:
          widget.tabType == 0 ? _buildFloatingActionButton(context) : null,
    );
  }

  /// Method that builds the list of [TaskCard] type objects to display on the screen.
  /// 
  /// Dissmissible is used for dissmissing tasks. Swiping from end to start removes and
  /// from start to end completes a task. Dissmiss action is handled by [_handleOnDismiss]
  /// function.
  Widget _buildListView() {
    return ListView.builder(
      itemCount: _taskList.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          child: TaskCard(
            _taskList[index],
            widget.tabType,
            widget.addTask,
            widget.updateTask
          ),
          background: _buildContainer(true),  // For completion.
          secondaryBackground: _buildContainer(false), // For remove.
          key: Key(_taskList[index].setDate.toString()),
          direction: widget.tabType == 2 // Tab type = 2 means Completed tab
              ? DismissDirection.endToStart // Swipe to only delete
              : DismissDirection.horizontal, // Swipe to both complete and delete
          onDismissed: (DismissDirection direction) =>
              _handleOnDismiss(direction, index),
          dismissThresholds: {
            DismissDirection.endToStart: 0.9,
            DismissDirection.startToEnd: 0.9,
          },
        );
      },
    );
  }

  /// Method to handle swipe to dismiss based on direction.
  void _handleOnDismiss(DismissDirection direction, int index) {
    _swipedTask = _taskList[index];
    _taskList.removeAt(index);

    setState(() {
      if (direction == DismissDirection.endToStart) {
        widget.removeTask(_swipedTask);
        Scaffold.of(context).showSnackBar(_deleteSnackBar);
      } else if (direction == DismissDirection.startToEnd) {
        widget.completeTask(_swipedTask);
        Scaffold.of(context).showSnackBar(_completeSnackBar);
      }
    });
  }

  /// Method for building the snack bars [_deleteSnackBar] and [_completeSnackBar].
  SnackBar _buildSnackBar(bool mode) {
    return SnackBar(
      content: Text('Task ' + (mode ? 'deleted' : 'completed')),
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: 'Undo ' + (mode ? 'delete' : 'complete'),
        textColor: mode ? Colors.red : Colors.green,
        onPressed: () {
          setState(() {
            if (mode) {
              widget.addTask(_swipedTask);
            } else {
              _swipedTask.completeDate = null;
              widget.updateTask(_swipedTask);
            }
          });
        },
      ),
    );
  }

  /// Method for building the container of the dissmissable widget.
  ///
  /// [mode] true means complete and false means remove.
  Widget _buildContainer(bool mode) {
    return Container(
      color: mode ? Colors.green : Colors.red,
      child: Row(
        children: <Widget>[
          Icon(
            mode ? Icons.check : Icons.delete,
            size: 35.0,
            color: Colors.white,
          )
        ],
        mainAxisAlignment:
            mode ? MainAxisAlignment.start : MainAxisAlignment.end,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0),
    );
  }

  /// Method for building the floating action button. It generates a new
  /// form for creating a new task. The button passes in [addTask] to the
  /// form for adding the new task to the list of tasks.
  FloatingActionButton _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskForm(null, widget.addTask, widget.updateTask)),
        );
      },
    );
  }
}