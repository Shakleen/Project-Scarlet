import 'package:flutter/material.dart';

import '../../entities/task_entity.dart';
import './task_card.dart';
import '../../pages/strategy_pages/task_form_page.dart';
import '../ui_elements/side_drawer.dart';

class TaskListView extends StatefulWidget {
  final int _tabNumber;
  final List<TaskEntity> _taskList;
  final Function _removeTask;
  final Function _addTask;
  final Function _completeTask;

  TaskListView(this._tabNumber, this._taskList, this._removeTask, this._addTask, this._completeTask);
  
  @override
  _TaskListViewState createState() {
    return _TaskListViewState();
  }
}

class _TaskListViewState extends State<TaskListView> {
  /// Method for creating the list of task card. Each task card
  /// contains the name and due date of the task entity housed within
  /// it. The list of task entities is passed in as [taskList]. Each
  /// card has the swipe functionality to dismiss it. It is implemented
  /// into the cards. The dismiss to delete uses [removeTask] function.
  Widget _buildListView(List<TaskEntity> taskList, Function removeTask, Function completeTask) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          // Setting up the background color that will be seen after swapping to dismiss
          background: Container(
            color: Colors.red,
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.delete,
                  size: 35.0,
                  color: Colors.white,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.end,
            ),
            padding: EdgeInsets.symmetric(horizontal: 25.0),
          ),
          key: Key(taskList[index].getName()),
          onDismissed: (DismissDirection direction) {
            removeTask(index);
          },
          direction: DismissDirection.endToStart,
          dismissThresholds: {DismissDirection.endToStart: 0.6},
          // Main task component
          child: TaskCard(taskList[index], index, removeTask, completeTask),
        );
      },
      itemCount: taskList.length,
    );
  }

  /// Method for building the floating action button. It generates a new
  /// form for creating a new task. The button passes in [addTask] to the
  /// form for adding the new task to the list of tasks.
  FloatingActionButton _buildFloatingActionButton(
      Function addTask, BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskForm(null, null)),
        );
        // addTask();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

          // Display the task which currently exist
          body: _buildListView(widget._taskList, widget._removeTask, widget._completeTask),

          // Floating action button for adding new tasks and goals
          floatingActionButton: widget._tabNumber == 0 ? 
              _buildFloatingActionButton(widget._addTask, context) : null,
        );
  }
}