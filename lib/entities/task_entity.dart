import 'package:flutter/material.dart';
import '../presentation/custom_icons.dart';

/// Entity class for tasks.
///
/// Each task has a unique [setDate] which is used to differentiate it from
/// other tasks in the database where it will be ultimately stored. Moreover,
/// a task is composed of having a [name], [dueDate], [completeDate],
/// [description], [priority], [location] and [difficulty]. [priority]
/// levels and [difficulty] levels are defined in the static maps called
/// [priorityLevels] and [difficultyLevels] respectively. The [columnNames]
/// define the different column names and types each of the attributes will
/// have in the database. [databaseConstraints] carries the database constraints
/// for the task database. The data is stored in a table named [tableName]. The
/// table has two views whose names are kept in [tableViewNames] list. Finally,
/// the file that keeps the data is called [databaseFileName].
class TaskEntity {
  static final Map<int, List> priorityLevels = const {
    0: ['Low', CustomIcons.low, Colors.black],
    1: ['Normal', CustomIcons.normal, Colors.green],
    2: ['Important', CustomIcons.important, Colors.purple],
    3: ['Urgent', CustomIcons.urgent, Colors.red],
  };
  static final Map<int, List> difficultyLevels = const {
    0: ['Easy', CustomIcons.low, Colors.black],
    1: ['Medium', CustomIcons.normal, Colors.green],
    2: ['Difficult', CustomIcons.important, Colors.purple],
    3: ['Hard', CustomIcons.urgent, Colors.red],
  };
  static final Map<int, List<String>> columnNames = const {
    0: ["Name", "TEXT"],
    1: ["DueDate", "DATETIME"],
    2: ["Description", "TEXT"],
    3: ["Priority", "TEXT"],
    4: ["Difficulty", "TEXT"],
    5: ["Location", "TEXT"],
    6: ["CompleteDate", "DATETIME"],
    7: ["SetDate", "DATETIME"],
    // 8: ["ID", "TEXT"],
  };
  static final Map<String, dynamic> taskFormData = {
    TaskEntity.columnNames[0][0]: null, // Name
    TaskEntity.columnNames[1][0]: DateTime.now(), // DueDate
    TaskEntity.columnNames[2][0]: null, // Description
    TaskEntity.columnNames[3][0]: 0, // Priority
    TaskEntity.columnNames[4][0]: 0, // Difficulty
    TaskEntity.columnNames[5][0]: null, // Location
    TaskEntity.columnNames[7][0]: DateTime.now(),
  };
  static final String tableName = "Tasks";
  static final List<String> tableViewNames = const [
    "TasksPending",
    "TasksCompleted",
  ];
  static final String databaseFileName = "TasksDatabase.db";
  static DateTime _convert(dynamic input) {
    return input != null
        ? input.runtimeType.toString() == 'DateTime'
            ? input
            : DateTime.parse(input)
        : null;
  }

  static Map<String, dynamic> toMap(TaskEntity task, bool mode) {
    final Map<String, dynamic> map = {};

    for (int keys in columnNames.keys)
      map[columnNames[keys][0]] = task.getTaskInfo(keys)?.toString();

    if (mode) map.remove(columnNames[7][0]);

    return map;
  }

  static TaskEntity fromMap(Map<String, dynamic> map) {
    final dynamic dueDate = map[columnNames[1][0]];
    final dynamic priority = map[columnNames[3][0]];
    final dynamic difficulty = map[columnNames[4][0]];
    final dynamic completeDate = map[columnNames[6][0]];
    final dynamic setDate = map[columnNames[7][0]];

    return TaskEntity(
      name: map[columnNames[0][0]],
      dueDate: _convert(dueDate),
      description: map[columnNames[2][0]],
      priority: priority.runtimeType == int ? priority : int.parse(priority),
      difficulty:
          difficulty.runtimeType == int ? difficulty : int.parse(difficulty),
      location: map[columnNames[5][0]],
      completeDate: _convert(completeDate),
      setDate: _convert(setDate),
    );
  }

  String name;
  DateTime dueDate;
  DateTime completeDate;
  String description;
  int priority;
  int difficulty;
  String location;
  DateTime setDate;

  /// Constructor for class.
  ///
  /// The constructor takes 2 required parameters. They are [name] and [dueDate].
  /// All the parameters are named parameters.
  TaskEntity({
    @required String name,
    @required DateTime dueDate,
    DateTime setDate,
    DateTime completeDate,
    String description,
    int priority = 0,
    int difficulty = 0,
    String location,
  }) {
    this.name = name;
    this.dueDate = dueDate;
    this.setDate = (setDate == null ? DateTime.now() : setDate);
    this.description = description;
    this.priority = priority;
    this.difficulty = difficulty;
    this.location = location;
    this.completeDate = completeDate;
  }

  /// Method for getting any information about a task by passing in an index
  /// that represents the task.
  dynamic getTaskInfo(int i) {
    switch (i) {
      case 0:
        return this.name;
      case 1:
        return this.dueDate;
      case 2:
        return this.description;
      case 3:
        return this.priority;
      case 4:
        return this.difficulty;
      case 5:
        return this.location;
      case 6:
        return this.completeDate;
      case 7:
        return this.setDate;
      default:
        return null;
    }
  }
}
