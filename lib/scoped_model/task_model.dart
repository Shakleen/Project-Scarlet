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
  static final Map<String, dynamic> taskFormData = {
    'name': null,
    'dueDate': DateTime.now(),
    'description': null,
    'priority': 0,
    'location': null
  };
  static final Uuid _uuid = Uuid();
  static final Map<int, String> priorityLevels = const {
    0: 'Low',
    1: 'Normal',
    2: 'Important',
    3: 'Urgent'
  };

  static Map<String, dynamic> toMap(TaskEntity task) {
    final Map<String, dynamic> map = {
      TaskDatabase.columnNames[0][0]: task.getID(),
      TaskDatabase.columnNames[1][0]: task.getName(),
      TaskDatabase.columnNames[2][0]: task.getDueDate()?.toString(),
      TaskDatabase.columnNames[3][0]: task.getDescription(),
      TaskDatabase.columnNames[4][0]: task.getPriority()?.toString(),
      TaskDatabase.columnNames[5][0]: task.getLocation(),
      TaskDatabase.columnNames[6][0]: task.getCompleteDate()?.toString(),
      TaskDatabase.columnNames[7][0]: task.getSetDate()?.toString(),
    };

    return map;
  }

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

  /// Used to get a specific task. The task at [index] in the list
  /// is returned. Performs proper checking before proceeding. Throws
  /// exception if checking shows error.
  Future<TaskEntity> getSelectedTask(TaskEntity task) {
    return TaskDatabase.taskDatabase.getTask(task.getID());
  }

  /// Used to add a new task to the list. Performs proper checking
  /// before proceeding. Throws exception if checking shows error.
  void addTask(String name, DateTime dueDate,
      [String description = null, int priority = 0, String location = null]) {
    if (name != null && dueDate != null) {
      TaskEntity task = TaskEntity(
        id: _uuid.v1(),
        name: name,
        dueDate: dueDate,
        description: description,
        priority: priority,
        location: location,
      );

      TaskDatabase.taskDatabase.insertTask(task);

      notifyListeners();
    } else {
      throw Exception('TaskModel - addTask - name and/or dueDate is null');
    }
  }

  /// Update [task] information.
  void updateTask(TaskEntity task, String name, DateTime dueDate,
      [String description = null, int priority = 0, String location = null]) {
    TaskEntity newTask = TaskEntity(
      id: task.getID(),
      name: name,
      dueDate: dueDate,
      description: description,
      priority: priority,
      location: location,
    );

    TaskDatabase.taskDatabase.updateTask(newTask, task.getID());

    notifyListeners();
  }

  /// Removes the [task].
  void removeTask(TaskEntity task) {
    TaskDatabase.taskDatabase.removeTask(task.getID());
  }

  /// Completes the [task].
  void completeTask(TaskEntity task) {
    task.setCompleteDate(DateTime.now());
    TaskDatabase.taskDatabase.updateTask(task, task.getID());
    notifyListeners();
  }
}

/*
[
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
  ]
*/
