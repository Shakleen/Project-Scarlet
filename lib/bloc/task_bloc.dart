import 'dart:async';

import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/controller/task_notification.dart';
import 'package:project_scarlet/entities/task_entity.dart';

class TaskBloc implements BlocBase {
  final _taskAllController = StreamController<List<TaskEntity>>.broadcast();
  final _taskUpcomingController =
      StreamController<List<TaskEntity>>.broadcast();
  final _taskOverDueController = StreamController<List<TaskEntity>>.broadcast();
  final _taskCompletedController =
      StreamController<List<TaskEntity>>.broadcast();

  TaskBloc() {
    getUpcomingTasks();
    getOverDueTasks();
    getCompletedTasks();
    getAllTasks();
  }

  Stream<List<TaskEntity>> get taskUpcomingStream =>
      _taskUpcomingController.stream;

  Stream<List<TaskEntity>> get taskOverDueStream =>
      _taskOverDueController.stream;

  Stream<List<TaskEntity>> get taskCompletedStream =>
      _taskCompletedController.stream;

  Stream<List<TaskEntity>> get taskAllStream => _taskAllController.stream;

  Stream getStream(int i) {
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
        return taskAllStream;
    }
  }

  dispose() {
    print('Disposing _taskcontroller!');
    _taskUpcomingController.close();
    _taskOverDueController.close();
    _taskCompletedController.close();
    _taskAllController.close();
  }

  void getAllTasks() async {
    _taskAllController.sink.add(await TaskDatabase.taskDatabase.getTasks(0));
  }

  void getUpcomingTasks() async {
    _taskUpcomingController.sink
        .add(await TaskDatabase.taskDatabase.getTasks(1));
  }

  void getOverDueTasks() async {
    _taskOverDueController.sink
        .add(await TaskDatabase.taskDatabase.getTasks(2));
  }

  void getCompletedTasks() async {
    _taskCompletedController.sink
        .add(await TaskDatabase.taskDatabase.getTasks(3));
  }

  addTask(TaskEntity task, {bool mode: true}) {
    //print('${task.name} ${task.id} ${task.description} ${task.location} ${task.setDate} ${task.completeDate} ${task.dueDate} ${task.difficulty} ${task.priority}');
    TaskDatabase.taskDatabase.insertTask(task).then((bool condition) {
      if (condition) {
        TaskDatabase.taskDatabase
            .getTaskDetails(task)
            .then((TaskEntity detailedTask) {
          TaskNotification().scheduleNotification(detailedTask);
//          if (mode) {
//            TaskStack.taskStack.addOperation(TaskOperation(
//                beforeValue: detailedTask,
//                afterValue: detailedTask,
//                type: 1,
//                perform: this.addTask,
//                revert: this.deleteTask));
//          }
        });
      }
    });
    getUpcomingTasks();
  }

  deleteTask(TaskEntity task, {bool mode: false}) {
    TaskDatabase.taskDatabase.removeTask(task).then((bool status) {
      TaskNotification().cancelNotification(task);
//      if (mode) {
//        TaskStack.taskStack.addOperation(TaskOperation(
//            beforeValue: task,
//            afterValue: task,
//            type: 2,
//            perform: this.removeTask,
//            revert: this.addTask));
//      }
    });
    getUpcomingTasks();
    getCompletedTasks();
    getOverDueTasks();
  }

  updateTask(TaskEntity task, {bool mode: false}) {
    TaskDatabase.taskDatabase.updateTask(task).then((bool condition) {
//      if (condition)
//        TaskDatabase.taskDatabase
//            .getTaskDetails(task)
//            .then((TaskEntity detailedTask) {
//          TaskNotification().scheduleNotification(detailedTask);
//        });
    });
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
//          if (mode) {
//            TaskStack.taskStack.addOperation(TaskOperation(
//                beforeValue: task,
//                afterValue: detailedTask,
//                type: 3,
//                perform: this.updateTask,
//                revert: this.updateTask));
//          }
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
