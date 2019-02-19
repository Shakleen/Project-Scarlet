import 'package:scoped_model/scoped_model.dart';

import '../entities/task_entity.dart';

/// The task model houses all the tasks of the user and also
/// implements the mecahnisms to interact with them.
///
/// This class is the way of interacting with the tasks. It stores
/// the tasks in a list called [_taskList] which is final by default.
/// It implements [addTask], [updateTask] and [removeTask] as a way
/// of modifying this list. Further more, [getTaskList] and [getSelectedTask]
/// can be used to get the whole list or just one task respectively.
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

  /// Returns the list of tasks as a new varaible.
  /// So the original one can't be editted outside the class.
  List<TaskEntity> getTaskList() {
    return List.from(_taskList);
  }

  /// Returns the total number of tasks in the list of tasks.
  int getTotalNumberOfTasks() {
    return _taskList.length;
  }

  /// Used to get a specific task. The task at [index] in the list
  /// is returned. Performs proper checking before proceeding. Throws
  /// exception if checking shows error.
  TaskEntity getSelectedTask(int index) {
    if (index >= 0 && index < _taskList.length) {
      return _taskList[index];
    } else {
      throw Exception('TaskModel - getSelectedTask - index out of bounds');
    }
  }

  /// Used to add a new task to the list. Performs proper checking
  /// before proceeding. Throws exception if checking shows error.
  void addTask(String name, DateTime dueDate,
      [String description = 'None',
      int priority = 0,
      String location = 'Unspecified']) {
    if (name != null && dueDate != null) {
      _taskList
          .add(new TaskEntity(name, dueDate, description, priority, location));
      notifyListeners();
    }  else {
      throw Exception('TaskModel - addTask - name and/or dueDate is null');
    }
  }

  /// Used to update a new task to the list. Performs proper checking
  /// before proceeding. Throws exception if checking shows error.
  void updateTask(int index, String name, DateTime dueDate,
      [String description = 'None',
      int priority = 0,
      String location = 'Unspecified']) {
    if (name != null && dueDate != null) {
      _taskList[index].setName(name);
      _taskList[index].setDate(dueDate);
      _taskList[index].setDescription(description);
      _taskList[index].setPriority(priority);
      _taskList[index].setLocation(location);
      notifyListeners();
    } else {
      throw Exception('TaskModel - updateTask - name and/or dueDate is null');
    }
  }

  /// Removes the task at position [index] in the list. Performs proper
  /// checking before proceeding. Throws exception if checking shows error.
  void removeTask(int index) {
    if (index >= 0 && index < _taskList.length) {
      _taskList.removeAt(index);
      notifyListeners();
    } else {
      throw Exception('TaskModel - removeTask - index out of bounds');
    }
  }
}
