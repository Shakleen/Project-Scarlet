import 'package:flutter/material.dart';
import 'package:project_scarlet/controller/task_search_delegate.dart';

class TaskSearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.search),
      onPressed: () {
        showSearch(context: context, delegate: TaskSearchDelegate());
      },
    );
  }
}
