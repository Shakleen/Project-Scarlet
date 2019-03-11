import 'dart:async';

import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/controller/task_notification.dart';
import 'package:project_scarlet/controller/task_manager.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/entities/task_operation.dart';

class TaskBloc implements BlocBase {
  final _taskUpcomingController =
      StreamController<List<TaskEntity>>.broadcast();
  final _taskOverDueController = StreamController<List<TaskEntity>>.broadcast();
  final _taskCompletedController =
      StreamController<List<TaskEntity>>.broadcast();
  int _upcomingTaskOffSet,
      _upcomingTaskAmount,
      _overDueTaskOffSet,
      _overDueTaskAmount,
      _completedTaskOffSet,
      _completedTaskAmount;

  TaskBloc() {
    _upcomingTaskAmount = _completedTaskAmount = _overDueTaskAmount = 6;
    _upcomingTaskOffSet = _completedTaskOffSet = _overDueTaskOffSet = 0;
  }

  void increment(int type) {
    switch (type) {
      case 0:
        _upcomingTaskOffSet += _upcomingTaskAmount;
        break;
      case 1:
        _overDueTaskOffSet += _overDueTaskAmount;
        break;
      case 2:
        _completedTaskOffSet += _completedTaskAmount;
        break;
    }
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
        return _upcomingTaskOffSet;
      case 1:
        return _overDueTaskOffSet;
      case 2:
        return _completedTaskOffSet;
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
      offset: _upcomingTaskOffSet,
      limit: _upcomingTaskAmount,
    ));
    _upcomingTaskOffSet += _upcomingTaskAmount;
    _overDueTaskOffSet = _completedTaskOffSet = 0;
  }

  void getOverDueTasks() async {
    _taskOverDueController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 2,
      offset: _overDueTaskOffSet,
      limit: _overDueTaskAmount,
    ));
    _overDueTaskOffSet += _overDueTaskAmount;
    _upcomingTaskOffSet = _completedTaskOffSet = 0;
  }

  void getCompletedTasks() async {
    _taskCompletedController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 3,
      offset: _completedTaskOffSet,
      limit: _completedTaskAmount,
    ));
    _completedTaskOffSet += _completedTaskAmount;
    _upcomingTaskOffSet = _overDueTaskOffSet = 0;
  }

  Future<bool> addTask(TaskEntity task) =>
      TaskDatabase.taskDatabase.insertTask(task)..then((bool status) {
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
