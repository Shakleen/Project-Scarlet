import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../entities/task_entity.dart';

class TaskModel extends Model {
  final List<TaskEntity> _taskList = [
    TaskEntity('Do push ups', DateTime(2019, 02, 28)),
    TaskEntity('Go shopping', DateTime(2019, 02, 19)),
    TaskEntity('Clean the car', DateTime(2019, 02, 8)),
    TaskEntity('Study ML', DateTime(2019, 02, 14)),
    TaskEntity('Make dinner', DateTime(2019, 02, 22)),
    TaskEntity('Check emails', DateTime(2019, 02, 11)),
    TaskEntity('Call parents', DateTime(2019, 02, 1))
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

  void addTask(String name, DateTime dueDate,
      [String description = 'None',
      int priority = 0,
      String location = 'Unspecified']) {
    _taskList
        .add(new TaskEntity(name, dueDate, description, priority, location));
    notifyListeners();
  }

  void updateTask(int index, String name, DateTime dueDate,
      [String description = 'None',
      int priority = 0,
      String location = 'Unspecified']) {
    _taskList[index].setName(name);
    _taskList[index].setDate(dueDate);
    _taskList[index].setDescription(description);
    _taskList[index].setPriority(priority);
    _taskList[index].setLocation(location);
    notifyListeners();
  }

  void removeTask(int index) {
    _taskList.removeAt(index);

    notifyListeners();
  }
}
