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

  TaskListView(this.tabNumber, this.getTaskList, this.addTask, this.removeTask,
      this.completeTask);

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
    Future<List<TaskEntity>> futureTaskList = widget.getTaskList();
    return FutureBuilder<List<TaskEntity>>(
        future: futureTaskList,
        builder: (
          BuildContext context,
          AsyncSnapshot<List<TaskEntity>> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.done) {
            _taskList = snapshot.hasData ? snapshot.data : [];
            return _buildListView();
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // TODO: Handle Error code
          }
        });
  }

  /// Method that builds the list of [TaskCard] type objects to display
  /// on the screen. 
  Widget _buildListView() {
    return ListView.builder(
      itemCount: _taskList.length,
      itemBuilder: (BuildContext context, int index) {
        // Dissmissible is needed for swapping to delete from right to left.
        return Dismissible(
          // Setting up the background color that will be seen after swapping to dismiss
          background: _buildContainer(
            Colors.green,
            Icons.check,
            MainAxisAlignment.start,
          ),
          secondaryBackground: _buildContainer(
            Colors.red,
            Icons.delete,
            MainAxisAlignment.end,
          ),
          key: Key(_taskList[index].getName()),
          direction: widget.tabNumber == 2
              ? DismissDirection.endToStart
              : DismissDirection.horizontal,
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart) {
              _setState(true, index);
            } else if (direction == DismissDirection.startToEnd) {
              _setState(false, index);
            }
            ;
          },
          dismissThresholds: {
            DismissDirection.endToStart: 0.6,
            DismissDirection.startToEnd: 0.6,
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

  /// Method for setting state on dissmiss.
  void _setState(bool mode, int index) {
    setState(() {
      final TaskEntity taskEntity = _taskList[index];
      _taskList.removeAt(index);
      mode ? widget.removeTask(taskEntity) : widget.completeTask(taskEntity);
    });
  }

  /// Method for building the container of the dissmissable widget.
  Widget _buildContainer(
      Color color, IconData icon, MainAxisAlignment alignment) {
    return Container(
      color: color,
      child: Row(
        children: <Widget>[
          Icon(
            icon,
            size: 35.0,
            color: Colors.white,
          )
        ],
        mainAxisAlignment: alignment,
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
