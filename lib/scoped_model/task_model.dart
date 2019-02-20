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

  /// Returns the filtered list of upcoming tasks as a new varaible.
  /// So the original one can't be editted outside the class.
  List<TaskEntity> getUpcomingTaskList() {
    return _taskList.where((TaskEntity task) {
      final bool isUpcoming = task.getDueDate().compareTo(DateTime.now()) >= 0;
      final bool isNotCompleted = task.getCompleteDate() == null;
      return isNotCompleted && isUpcoming;
    }).toList();
  }

  /// Returns the filtered list of completed tasks as a new varaible.
  /// So the original one can't be editted outside the class.
  List<TaskEntity> getCompletedTaskList() {
    return _taskList.where((TaskEntity task) {
      final bool isCompleted = task.getCompleteDate() != null;
      return isCompleted;
    }).toList();
  }

  /// Returns the filtered list of overdue tasks as a new varaible.
  /// So the original one can't be editted outside the class.
  List<TaskEntity> getOverdueTaskList() {
    return _taskList.where((TaskEntity task) {
      final bool isOverdue = task.getDueDate().compareTo(DateTime.now()) < 0;
      final bool isNotCompleted = task.getCompleteDate() == null;
      return isNotCompleted && isOverdue;
    }).toList();
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
    } else {
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
      _taskList[index].setDueDate(dueDate);
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

  /// Completes the task at position [index] in the list. Performs proper
  /// checking before proceeding. Throws exception if checking shows error.
  void completeTask(TaskEntity task) {
    int index =_taskList.indexOf(task);
    
    if (index >= 0 && index < _taskList.length) {
      if (_taskList[index].getCompleteDate() == null) {
        print(_taskList[index].getName() + ' was completed');
        _taskList[index].setCompleteDate(DateTime.now());
        notifyListeners();
      } else {
        throw Exception('TaskModel - completeTask - task previously completed');
      }
    } else {
      throw Exception('TaskModel - completeTask - index out of bounds');
    }
  }
}
