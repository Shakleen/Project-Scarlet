import 'dart:async';

import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/controller/task_notification.dart';
import 'package:project_scarlet/entities/task_entity.dart';

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
    _upcomingTaskAmount = _completedTaskAmount = _overDueTaskAmount = 10;
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
    print('Disposing _taskcontroller!');
    _taskUpcomingController.close();
    _taskOverDueController.close();
    _taskCompletedController.close();
  }

  void getUpcomingTasks() async {
    print('Get upcoming tasks called!');
    _taskUpcomingController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 1,
      offset: _upcomingTaskOffSet,
      limit: _upcomingTaskAmount,
    ));
    _upcomingTaskOffSet += _upcomingTaskAmount;
  }

  void getOverDueTasks() async {
    print('Get Over due tasks called!');
    _taskOverDueController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 2,
      offset: _overDueTaskOffSet,
      limit: _overDueTaskAmount,
    ));
    _overDueTaskOffSet += _overDueTaskAmount;
  }

  void getCompletedTasks() async {
    print('Get completed tasks called!');
    _taskCompletedController.sink
        .add(await TaskDatabase.taskDatabase.getTasksByOffset(
      type: 3,
      offset: _completedTaskOffSet,
      limit: _completedTaskAmount,
    ));
    _completedTaskOffSet += _completedTaskAmount;
  }

  addTask(TaskEntity task, {bool mode: true}) {
    TaskDatabase.taskDatabase.insertTask(task).then((bool condition) {
      if (condition) {
        TaskDatabase.taskDatabase
            .getTaskDetails(task)
            .then((TaskEntity detailedTask) {
          TaskNotification().scheduleNotification(detailedTask);
        });
      }
    });
    getUpcomingTasks();
  }

  deleteTask(TaskEntity task, {bool mode: false}) {
    TaskDatabase.taskDatabase.removeTask(task).then((bool status) {
      TaskNotification().cancelNotification(task);
    });
    getUpcomingTasks();
    getCompletedTasks();
    getOverDueTasks();
  }

  updateTask(TaskEntity task, {bool mode: false}) {
    TaskDatabase.taskDatabase.updateTask(task).then((bool condition) {});
    getUpcomingTasks();
    getOverDueTasks();
  }

  completeTask(TaskEntity task, {bool mode: false}) {
    final TaskEntity modifiedTask = task;
    modifiedTask.completeDate = DateTime.now();
    TaskDatabase.taskDatabase.updateTask(modifiedTask).then((bool condition) {
      if (condition)
        TaskDatabase.taskDatabase
            .getTaskDetails(modifiedTask)
            .then((TaskEntity detailedTask) {
          TaskNotification().cancelNotification(detailedTask);
        });
    });
    getUpcomingTasks();
    getOverDueTasks();
    getCompletedTasks();
  }

  Future<TaskEntity> getTaskDetails(TaskEntity task) {
    return TaskDatabase.taskDatabase.getTaskDetails(task);
  }
}
