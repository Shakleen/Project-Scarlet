import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/side_drawer.dart';
import '../widgets/task_card.dart';
import '../entities/task_entity.dart';
import '../scoped_model/task_model.dart';

// import 'package:unicorndial/unicorndial.dart';

class StrategicPage extends StatefulWidget {
  @override
  _StrategicPage createState() {
    return _StrategicPage();
  }
}

class _StrategicPage extends State<StrategicPage> {
  Widget _buildListView(List<TaskEntity> taskList, Function removeTask) {
    return ListView.builder(
        itemBuilder: (BuildContext context, int index) => TaskCard(
            taskList[index].name,
            taskList[index].dueDate,
            removeTask,
            index),
        itemCount: taskList.length,
      );
  }

  FloatingActionButton _buildFloatingActionButton(Function addTask) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.red,
      onPressed: () {
        // TODO: Create a function to add goals and tasks.
        addTask();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TaskModel>(
      builder: (BuildContext context, Widget child, TaskModel model) {
        return Scaffold(
          // Title of the app bar
          appBar: AppBar(
            title: Text('Strategic'),
          ),

          // Side drawer
          drawer: SideDrawer(4),

          // Display the task which currently exist
          body: _buildListView(model.getTaskList(), model.removeTask),

          // Floating action button for adding new tasks and goals
          floatingActionButton: _buildFloatingActionButton(model.addTask),
        );
      },
    );
  }
}
