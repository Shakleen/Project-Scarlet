import 'package:scoped_model/scoped_model.dart';

import '../entities/task_entity.dart';
import 'package:uuid/uuid.dart';
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
  static final Map<int, dynamic> columnNames = const {
    0: ["UUID", "Text"],
    1: ["Name", "Text"],
    2: ["DueDate", "Text"],
    3: ["Description", "Text"],
    4: ["Priority", "Number"],
    5: ["Location", "Text"],
    6: ["CompleteDate", "Text"],
    7: ["SetDate", "Text"]
  };
  static final String tableName = "Tasks";
  static final String databaseFileName = "TasksDatabase.db";

  static final Uuid _uuid = Uuid();
  final List<TaskEntity> _taskList = [
    TaskEntity(
      id: _uuid.v1(),
      name: 'Do push ups',
      dueDate: DateTime(2019, 02, 28, 5, 45),
    ),
    TaskEntity(
      id: _uuid.v1(),
      name: 'Go shopping',
      dueDate: DateTime(2019, 02, 19, 4, 25),
    ),
    TaskEntity(
      id: _uuid.v1(),
      name: 'Clean the car',
      dueDate: DateTime(2019, 02, 8, 6, 18),
    ),
    TaskEntity(
      id: _uuid.v1(),
      name: 'Study ML',
      dueDate: DateTime(2019, 02, 14, 20, 24),
    ),
    TaskEntity(
      id: _uuid.v1(),
      name: 'Make dinner',
      dueDate: DateTime(2019, 02, 22, 12, 34),
    ),
    TaskEntity(
      id: _uuid.v1(),
      name: 'Check emails',
      dueDate: DateTime(2019, 02, 11, 18, 54),
    ),
    TaskEntity(
      id: _uuid.v1(),
      name: 'Call parents',
      dueDate: DateTime(2019, 02, 1, 0, 24),
    )
  ];
  static final Map<int, String> priorityLevels = const {
    0: 'Low',
    1: 'Normal',
    2: 'Important',
    3: 'Urgent'
  };

  static Map<String, dynamic> toMap(TaskEntity task) {
    final Map<String, dynamic> map = {
        columnNames[0][0]: task.getID(),
        columnNames[1][0]: task.getName(),
        columnNames[2][0]: task.getDueDate()?.toString(),
        columnNames[3][0]: task.getDescription(),
        columnNames[4][0]: task.getPriority()?.toString(),
        columnNames[5][0]: task.getLocation(),
        columnNames[6][0]: task.getCompleteDate()?.toString(),
        columnNames[7][0]: task.getSetDate()?.toString(),
      };

    return map;
  } 

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
      TaskEntity task = new TaskEntity(
        id: _uuid.v1(),
        name: name,
        dueDate: dueDate,
        description: description,
        priority: priority,
        location: location,
      );

      _taskList.add(task);

      TaskDatabase.taskDatabase.insertTask(task);

      notifyListeners();
    } else {
      throw Exception('TaskModel - addTask - name and/or dueDate is null');
    }
  }

  /// Used to update a new task to the list. Performs proper checking
  /// before proceeding. Throws exception if checking shows error.
  void updateTask(TaskEntity task, String name, DateTime dueDate,
      [String description = 'None',
      int priority = 0,
      String location = 'Unspecified']) {
    int index = _taskList.indexOf(task);

    if (index >= 0 && index < _taskList.length) {
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
    } else {
      throw Exception('TaskModel - updateTask - task not found');
    }
  }

  /// Removes the [task] in the list. Performs proper
  /// checking before proceeding. Throws exception if checking shows error.
  void removeTask(TaskEntity task) {
    int index = _taskList.indexOf(task);

    if (index >= 0 && index < _taskList.length) {
      _taskList.removeAt(index);
      notifyListeners();
    } else {
      throw Exception('TaskModel - removeTask - task not found');
    }
  }

  /// Completes the [task]  in the list. Performs proper
  /// checking before proceeding. Throws exception if checking shows error.
  void completeTask(TaskEntity task) {
    int index = _taskList.indexOf(task);

    if (index >= 0 && index < _taskList.length) {
      if (_taskList[index].getCompleteDate() == null) {
        print(_taskList[index].getName() + ' was completed');
        _taskList[index].setCompleteDate(DateTime.now());
        notifyListeners();
      } else {
        throw Exception('TaskModel - completeTask - task previously completed');
      }
    } else {
      throw Exception('TaskModel - completeTask - task not found');
    }
  }
}
