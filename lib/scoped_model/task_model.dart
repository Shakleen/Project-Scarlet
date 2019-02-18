import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../entities/task_entity.dart';

class TaskModel extends Model {
  List<TaskEntity> _taskList = [
    TaskEntity(name: 'Do push ups', dueDate: DateTime(2019, 02, 28)),
    TaskEntity(name: 'Go shopping', dueDate: DateTime(2019, 02, 19)),
    TaskEntity(name: 'Clean the car', dueDate: DateTime(2019, 02, 8)),
    TaskEntity(name: 'Study ML', dueDate: DateTime(2019, 02, 14)),
    TaskEntity(name: 'Make dinner', dueDate: DateTime(2019, 02, 22)),
    TaskEntity(name: 'Check emails', dueDate: DateTime(2019, 02, 11)),
    TaskEntity(name: 'Call parents', dueDate: DateTime(2019, 02, 1))
  ];
  int _selectedTask = null;

  List<TaskEntity> getTaskList() {
    return List.from(_taskList);
  }

  int getTotalNumberOfTasks() {
    return _taskList.length;
  }

  void selectTask(int index) {
    _selectedTask = index;
  }

  TaskEntity getSelectedTask(int index) {
    _selectedTask = index;
    return _taskList[index];
  }

  void addTask(
      {@required String name,
      @required DateTime dueDate,
      String description = 'None',
      String priority = 'Normal',
      String location = 'Unspecified'}) {
    _taskList.add(TaskEntity(
        name: name,
        dueDate: dueDate,
        description: description,
        priority: priority,
        location: location));

    notifyListeners();
  }

  void removeTask(int index) {
    _taskList.removeAt(index);

    notifyListeners();
  }
}
