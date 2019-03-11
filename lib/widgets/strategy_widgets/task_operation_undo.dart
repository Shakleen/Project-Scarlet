import 'package:flutter/material.dart';
import 'package:project_scarlet/controller/task_manager.dart';

class TaskOperationUndo extends StatelessWidget {
  TaskOperationUndo();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.undo),
      onPressed: () {
        if (TaskManager.taskManager.nonEmpty) {
          TaskManager.taskManager.undoOperation().then((bool status) {
            if (status != null) {
              String text = "successful";
              Color color = Colors.blueAccent;

              if (status == false) {
                text = "failed!";
                color = Colors.redAccent;
              }

              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Undo $text"),
                duration: Duration(seconds: 2),
                backgroundColor: color,
              ));
            }
          });
        }
      },
    );
  }
}
