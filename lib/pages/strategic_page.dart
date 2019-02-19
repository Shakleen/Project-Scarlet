import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/side_drawer.dart';
import '../widgets/task_card.dart';
import '../entities/task_entity.dart';
import '../scoped_model/task_model.dart';

import '../pages/task_form_page.dart';

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
          child: TaskCard(
            taskList[index],
            index,
            removeTask
          ),
        );
      },
      itemCount: taskList.length,
    );
  }

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
          floatingActionButton:
              _buildFloatingActionButton(model.addTask, context),
        );
      },
    );
  }
}
