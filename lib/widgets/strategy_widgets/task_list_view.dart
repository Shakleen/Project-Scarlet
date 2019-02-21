import 'package:flutter/material.dart';

import '../../entities/task_entity.dart';
import './task_card.dart';
import '../../pages/strategy_pages/task_form_page.dart';

class TaskListView extends StatefulWidget {
  final int tabNumber;
  final List<TaskEntity> taskList;
  final Function removeTask;
  final Function addTask;
  final Function completeTask;

  TaskListView(this.tabNumber, this.taskList, this.removeTask, this.addTask,
      this.completeTask);

  @override
  _TaskListViewState createState() {
    return _TaskListViewState();
  }
}

class _TaskListViewState extends State<TaskListView> {
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

  /// Method for creating the list of task card. Each task card
  /// contains the name and due date of the task entity housed within
  /// it. The list of task entities is passed in as [taskList]. Each
  /// card has the swipe functionality to dismiss it. It is implemented
  /// into the cards. The dismiss to delete uses [removeTask] function.
  Widget _buildListView(
      List<TaskEntity> taskList, Function removeTask, Function completeTask) {
    return ListView.builder(
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
          key: Key(taskList[index].getName()),
          onDismissed: (DismissDirection direction) {
            setState(() {
              if (direction == DismissDirection.endToStart) {
                removeTask(taskList[index]);
              } else if (direction == DismissDirection.startToEnd) {
                completeTask(taskList[index]);
              }
            });
          },
          dismissThresholds: {
            DismissDirection.endToStart: 0.6,
            DismissDirection.startToEnd: 0.6,
          },
          // Main task component
          child: TaskCard(
            taskList[index],
            widget.tabNumber,
          ),
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
          MaterialPageRoute(builder: (context) => TaskForm(null)),
        );
        // addTask();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Display the task which currently exist
      body: _buildListView(
          widget.taskList, widget.removeTask, widget.completeTask),

      // Floating action button for adding new tasks and goals
      floatingActionButton: widget.tabNumber == 0
          ? _buildFloatingActionButton(widget.addTask, context)
          : null,
    );
  }
}