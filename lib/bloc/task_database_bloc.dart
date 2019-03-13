import 'dart:async';

import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/controller/task_manager.dart';
import 'package:project_scarlet/controller/task_notification.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/entities/task_operation.dart';

class TaskDatabaseBloc implements BlocBase {
  final StreamController<List<TaskEntity>> _taskUpcomingController =
      StreamController<List<TaskEntity>>.broadcast();
  final StreamController<List<TaskEntity>> _taskOverDueController =
      StreamController<List<TaskEntity>>.broadcast();
  final StreamController<List<TaskEntity>> _taskCompletedController =
  StreamController<List<TaskEntity>>.broadcast();
  int _upcomingOffSet, _upcomingAmount;
  int _overDueOffSet, _overDueAmount;
  int _completedOffSet, _completedAmount;

  TaskDatabaseBloc() {
    _upcomingAmount = _completedAmount = _overDueAmount = 6;
    _upcomingOffSet = _completedOffSet = _overDueOffSet = 0;
  }



  Stream<List<TaskEntity>> get taskUpcomingStream =>
      _taskUpcomingController.stream;

  Stream<List<TaskEntity>> get taskOverDueStream =>
      _taskOverDueController.stream;

  Stream<List<TaskEntity>> get taskCompletedStream =>
      _taskCompletedController.stream;

  Stream<List<TaskEntity>> getStream(int i) {
    switch (i) {
      case 0:
        getUpcomingTasks();
        return taskUpcomingStream;
      case 1:
        getOverDueTasks();
        return taskOverDueStream;
      case 2:
        getCompletedTasks();
        return taskCompletedStream;
      default:
        return null;
    }
  }

  int getOffset(int type) {
    switch (type) {
      case 0:
        return _upcomingOffSet;
      case 1:
        return _overDueOffSet;
      case 2:
        return _completedOffSet;
      default:
        return null;
    }
  }

  dispose() {
    _taskUpcomingController.close();
    _taskOverDueController.close();
    _taskCompletedController.close();
  }

  void getUpcomingTasks() async {
    _taskUpcomingController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 1,
      offset: _upcomingOffSet,
      limit: _upcomingAmount,
    ));
    _upcomingOffSet += _upcomingAmount;
    _overDueOffSet = _completedOffSet = 0;
  }

  void getOverDueTasks() async {
    _taskOverDueController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 2,
      offset: _overDueOffSet,
      limit: _overDueAmount,
    ));
    _overDueOffSet += _overDueAmount;
    _upcomingOffSet = _completedOffSet = 0;
  }

  void getCompletedTasks() async {
    _taskCompletedController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 3,
      offset: _completedOffSet,
      limit: _completedAmount,
    ));
    _completedOffSet += _completedAmount;
    _upcomingOffSet = _overDueOffSet = 0;
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

  Future<bool> completeTask(TaskEntity task) {
    final TaskEntity modifiedTask = task;
    modifiedTask.completeDate = DateTime.now();
    return TaskDatabase.taskDatabase
        .updateTask(modifiedTask)
        .then((bool status) {
      _afterComplete(status, task);
      return status;
    });
  }

  Future<TaskEntity> getTaskDetails(TaskEntity task) =>
      TaskDatabase.taskDatabase.getTaskDetails(task);

  void _addOperation(
    TaskEntity task,
    Future<bool> Function(TaskEntity task) toRevert,
  ) =>
      TaskManager.taskManager.addOperation(TaskOperation(
        task: task,
        revertOperation: toRevert,
      ));

  void _afterComplete(bool status, TaskEntity task) {
    if (status) {
      TaskDatabase.taskDatabase
          .getTaskDetails(task)
          .then((TaskEntity detailedTask) {
        TaskNotification().cancelNotification(detailedTask);
        task.completeDate = null;
        _addOperation(task, updateTask);
      });
    }
  }

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
