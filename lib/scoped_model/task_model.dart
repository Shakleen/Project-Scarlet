import 'package:scoped_model/scoped_model.dart';
import 'package:intl/intl.dart';

import '../entities/task_entity.dart';
import '../controller/task_database.dart';

/// The task model houses all the tasks of the user and also
/// implements the mecahnisms to interact with them.
///
/// This class is the way of interacting with the tasks. It stores
/// the tasks in a list called [_taskList] which is final by default.
/// It implements [addTask], [updateTask] and [removeTask] as a way
/// of modifying this list. Further more, [getTaskList] and [getSelectedTask]
/// can be used to get the whole list or just one task respectively.
class TaskModel extends Model {
  static final DateFormat dateFormatter =
      DateFormat("EEEE, dd/MM/yyyy 'at' hh:mm a");

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
    return TaskDatabase.taskDatabase.insertTask(task);
  }

  /// Update [task] information.
  Future<bool> updateTask(TaskEntity task) {
    return TaskDatabase.taskDatabase.updateTask(task);
  }

  /// Removes the [task].
  Future<bool> removeTask(TaskEntity task) {
    return TaskDatabase.taskDatabase.removeTask(task);
  }

  /// Completes the [task].
  Future<bool> completeTask(TaskEntity task) {
    task.completeDate = DateTime.now();
    return TaskDatabase.taskDatabase.updateTask(task);
  }
}
