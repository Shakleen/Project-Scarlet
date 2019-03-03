import 'package:scoped_model/scoped_model.dart';
import '../controller/task_notification.dart';
import '../entities/task_entity.dart';
import '../controller/task_database.dart';

/// The task model houses all the tasks of the user and also
/// implements the mecahnisms to interact with them.
mixin TaskModel on Model {
  /// Returns the filtered list of upcoming tasks as a new varaible.
  /// So the original one can't be editted outside the class.
  Future<List<TaskEntity>> getUpcomingTaskList() {
    return TaskDatabase.taskDatabase.getTasks(1);
  }

  /// Returns the filtered list of completed tasks as a new varaible.
  /// So the original one can't be editted outside the class.
  Future<List<TaskEntity>> getCompletedTaskList() {
    return TaskDatabase.taskDatabase.getTasks(3);
  }

  /// Returns the filtered list of overdue tasks as a new varaible.
  /// So the original one can't be editted outside the class.
  Future<List<TaskEntity>> getOverdueTaskList() {
    return TaskDatabase.taskDatabase.getTasks(2);
  }

  /// Used to add a new task to the list. Performs proper checking
  /// before proceeding. Throws exception if checking shows error.
  Future<bool> addTask(TaskEntity task) {
    return TaskDatabase.taskDatabase.insertTask(task).then((bool condition) {
      if (condition)
        TaskDatabase.taskDatabase
            .getTaskDetails(task)
            .then((TaskEntity detailedTask) {
          TaskNotification().scheduleNotification(detailedTask);
        });
    });
  }

  /// Update [task] information.
  Future<bool> updateTask(TaskEntity task) {
    return TaskDatabase.taskDatabase.updateTask(task).then((bool condition) {
      if (condition)
        TaskDatabase.taskDatabase
            .getTaskDetails(task)
            .then((TaskEntity detailedTask) {
          TaskNotification().scheduleNotification(detailedTask);
        });
    });
  }

  /// Removes the [task].
  Future<void> removeTask(TaskEntity task) {
    TaskDatabase.taskDatabase
        .getTaskDetails(task)
        .then((TaskEntity detailedTask) {
      TaskDatabase.taskDatabase.removeTask(detailedTask);
      TaskNotification().cancelNotification(detailedTask);
    });
  }

  /// Completes the [task].
  Future<bool> completeTask(TaskEntity task) {
    task.completeDate = DateTime.now();
    return TaskDatabase.taskDatabase.updateTask(task).then((bool condition) {
      if (condition)
        TaskDatabase.taskDatabase
            .getTaskDetails(task)
            .then((TaskEntity detailedTask) {
          TaskNotification().cancelNotification(detailedTask);
        });
    });
  }
}
