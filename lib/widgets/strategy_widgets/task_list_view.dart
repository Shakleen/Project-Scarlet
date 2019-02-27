import 'package:flutter/material.dart';

import '../../entities/task_entity.dart';
import './task_card.dart';
import '../../pages/strategy_pages/task_form_page.dart';

/// A StatefulWidget class which is resposible for displaying
/// the list of tasks in a specific category.
///
/// The categories of tasks are upcoming, overdue and completed.
/// The class expects to receive 5 arguments when a object is created.
/// These are [tabNumber] representing the different categories,
/// [getTaskList] which is a function for getting task data from the
/// data base, [removeTask] which is a function for removing a task
/// from the database, [addTask] which is a function for adding a new
/// task to the database and [completeTask] which is a function for
/// marking a task as complete.
class TaskListView extends StatefulWidget {
  final int tabNumber;
  final Function getTaskList;
  final Function removeTask;
  final Function completeTask;
  final Function addTask;
  final Function updateTask;

  TaskListView(
    this.tabNumber,
    this.getTaskList,
    this.addTask,
    this.removeTask,
    this.completeTask,
    this.updateTask,
  );

  @override
  _TaskListViewState createState() {
    return _TaskListViewState();
  }
}

/// A stateless widget class for our stateful widget class.
///
/// The stateless widget will change its state in two cases. These are
/// when a TaskCard widget has been dismissed for removal or for completion.
class _TaskListViewState extends State<TaskListView> {
  List<TaskEntity> _taskList = [];
  SnackBar deleteSnackBar, completeSnackBar;
  TaskEntity swipedTask;

  SnackBar _buildSnackBar(bool mode) {
    return SnackBar(
      content: Text(mode ? 'Task deleted' : 'Task completed'),
      duration: Duration(seconds: 4),
      action: SnackBarAction(
        label: 'Undo' + (mode ? ' delete' : ' complete'),
        textColor: mode ? Colors.red : Colors.green,
        onPressed: () {
          setState(() {
            if (mode) {
              widget.addTask(swipedTask);
            } else {
              swipedTask.completeDate = null;
              widget.updateTask(swipedTask);
            }
          });
        },
      ),
    );
  }

  @override
  void initState() {
    deleteSnackBar = _buildSnackBar(true);
    completeSnackBar = _buildSnackBar(false);
    super.initState();
  }

  /// Method for building the widget.
  ///
  /// It makes a call to [_buildFuture]
  /// method for building the body and [_buildFloatingActionButton] to
  /// make a Floating action button.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the task which currently exist
      body: _buildFuture(),

      // Floating action button for adding new tasks and goals
      floatingActionButton:
          widget.tabNumber == 0 ? _buildFloatingActionButton(context) : null,
    );
  }

  /// Method that implements future builder class to create a widget.
  ///
  /// This method uses [FutureBuilder] class to create a widget that
  /// depends on data from the SQLite database. The type of future is
  /// List<TaskEntity>.
  ///
  /// The method calls [_buildListView] method to build the list view
  /// with whatever data it gets from the database. The method creates
  /// a [CircularProgressIndicator] when it is waiting for data from
  /// the database.
  Widget _buildFuture() {
    return FutureBuilder<List<TaskEntity>>(
      future: widget.getTaskList(),
      builder:
          (BuildContext context, AsyncSnapshot<List<TaskEntity>> snapshot) {
        // The future is done processing and returned something.
        if (snapshot.connectionState == ConnectionState.done) {
          // If the future retuned some data then set it to _taskList otherwise
          // set it as empty list.
          _taskList = snapshot.hasData ? snapshot.data : [];

          // In case the future ran into some error it will be processed here.
          if (snapshot.hasError) {
            // TODO: Handle Error code
          }

          return _buildListView();
        }
        // In case the future isn't done processing, a progress indicator will be
        // shown
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  /// Method that builds the list of [TaskCard] type objects to display
  /// on the screen.
  Widget _buildListView() {
    return ListView.builder(
      itemCount: _taskList.length,
      itemBuilder: (BuildContext context, int index) {
        // Dissmissible is needed for swapping to delete from right to left.
        return Dismissible(
          // Background for swapping to delete task
          background: _buildContainer(true),
          // Background for swapping to finish task
          secondaryBackground: _buildContainer(false),
          key: Key(_taskList[index].setDate.toString()),

          // Directions allowed for swapping. For completed tasks only delete.
          // For the rest swipe left to delete and right to complete.
          direction: widget.tabNumber == 2
              ? DismissDirection.endToStart
              : DismissDirection.horizontal,

          // What to do on dismiss based on direction
          onDismissed: (DismissDirection direction) =>
              _handleOnDismiss(direction, index),

          // How far to swipe to activate onDismiss
          dismissThresholds: {
            DismissDirection.endToStart: 0.9,
            DismissDirection.startToEnd: 0.9,
          },

          // Main task component
          child: TaskCard(
            _taskList[index],
            widget.tabNumber,
          ),
        );
      },
    );
  }

  /// Method to handle swipe to dismiss based on direction
  void _handleOnDismiss(DismissDirection direction, int index) {
    swipedTask = _taskList[index];
    _taskList.removeAt(index);

    setState(() {
      if (direction == DismissDirection.endToStart) {
        widget.removeTask(swipedTask);
        Scaffold.of(context).showSnackBar(deleteSnackBar);
      } else if (direction == DismissDirection.startToEnd) {
        widget.completeTask(swipedTask);
        Scaffold.of(context).showSnackBar(completeSnackBar);
      }
    });
  }

  /// Method for building the container of the dissmissable widget.
  ///
  /// [mode] true means check off and false means remove.
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
          MaterialPageRoute(builder: (context) => TaskForm(null)),
        );
      },
    );
  }
}
