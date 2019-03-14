import 'dart:async';

import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/controller/task_manager.dart';
import 'package:project_scarlet/controller/task_notification.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/entities/task_operation.dart';

class TaskDatabaseBloc implements BlocBase {
  final StreamController<List<TaskEntity>> _taskListController =
  StreamController<List<TaskEntity>>.broadcast();
  final int _fetchAmount = 6;
  int _current, _taskListOffset, _taskListAmount;

  TaskDatabaseBloc() {
    _taskListAmount = _fetchAmount;
    _current = _taskListOffset = 0;
  }

  Stream<List<TaskEntity>> get taskListStream => _taskListController.stream;

  void changeStream(int i) {
    if (_current != i) {
      _current = i;
      _taskListOffset = 0;
      _taskListAmount = _fetchAmount;
    }
  }

  Stream<List<TaskEntity>> getStream() {
    getTasks();
    return taskListStream;
  }

  int getOffset(int type) => _taskListOffset;

  dispose() => _taskListController.close();

  void getTasks() async {
    _taskListController.sink.add(await TaskDatabase.taskDatabase
        .getTasks(
      type: _current,
      offset: _taskListOffset,
      limit: _taskListAmount,
    )
        .then((List<TaskEntity> list) {
      if (list.isNotEmpty) _taskListOffset += _taskListAmount;
      return list;
    }));
  }

  Future<bool> addTask(TaskEntity task) =>
      TaskDatabase.taskDatabase.insertTask(task)
        ..then((bool status) {
          _afterAdd(status, task);
          return status;
        });

  Future<bool> deleteTask(TaskEntity task) =>
      TaskDatabase.taskDatabase.removeTask(task).then((bool status) {
        _afterDelete(status, task);
        return status;
      });

  Future<bool> updateTask(TaskEntity task) =>
      TaskDatabase.taskDatabase.updateTask(task);

  Future<TaskEntity> getTaskDetails(TaskEntity task) =>
      TaskDatabase.taskDatabase.getTaskDetails(task);

  void _addOperation(TaskEntity task,
      Future<bool> Function(TaskEntity task) toRevert,) =>
      TaskManager.taskManager.addOperation(TaskOperation(
        task: task,
        revertOperation: toRevert,
      ));

  void _afterDelete(bool status, TaskEntity task) {
    if (status) {
      TaskNotification().cancelNotification(task);
      _addOperation(task, addTask);
    }
  }

  void _afterAdd(bool status, TaskEntity task) {
    if (status) {
      TaskDatabase.taskDatabase
          .getTaskDetails(task)
          .then((TaskEntity detailedTask) {
        TaskNotification().scheduleNotification(detailedTask);
      });
    }
  }
}
