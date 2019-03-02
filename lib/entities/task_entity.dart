import 'package:flutter/material.dart';
import '../presentation/custom_icons.dart';

/// Entity class for tasks.
class TaskEntity {
  static final Map<int, List<dynamic>> priorityLevels = const {
    0: ['Low', CustomIcons.low, Colors.black],
    1: ['Normal', CustomIcons.normal, Colors.green],
    2: ['Important', CustomIcons.important, Colors.purple],
    3: ['Urgent', CustomIcons.urgent, Colors.red],
  },
      difficultyLevels = const {
    0: ['Easy', CustomIcons.low, Colors.black],
    1: ['Medium', CustomIcons.normal, Colors.green],
    2: ['Difficult', CustomIcons.important, Colors.purple],
    3: ['Hard', CustomIcons.urgent, Colors.red],
  },
      columnNames = const {
    0: ["Name", "TEXT"],
    1: ["DueDate", "DATETIME"],
    2: ["Description", "TEXT"],
    3: ["Priority", "TEXT"],
    4: ["Difficulty", "TEXT"],
    5: ["Location", "TEXT"],
    6: ["CompleteDate", "DATETIME"],
    7: ["SetDate", "DATETIME"],
  };
  static final Map<String, dynamic> taskFormData = {
    TaskEntity.columnNames[0][0]: null, // Name
    TaskEntity.columnNames[1][0]: DateTime.now(), // Due Date
    TaskEntity.columnNames[2][0]: null, // Description
    TaskEntity.columnNames[3][0]: 0, // Priority
    TaskEntity.columnNames[4][0]: 0, // Difficulty
    TaskEntity.columnNames[5][0]: null, // Location
    TaskEntity.columnNames[7][0]: DateTime.now(), // Set date
  };
  static final String primaryKey = columnNames[7][0],
      tableName = "Tasks",
      databaseFileName = "TasksDatabase.db";
  static final List<String> tableViewNames = const [
    "TasksPending",
    "TasksCompleted",
  ];

  static DateTime _convertDate(dynamic input) => input != null
      ? input.runtimeType.toString() == 'DateTime'
          ? input
          : DateTime.parse(input)
      : null;

  static int _convertInt(dynamic input) =>
      input.runtimeType == int ? input : int.parse(input);

  static Map<String, dynamic> toMap(TaskEntity task, bool mode) {
    final Map<String, dynamic> map = {};

    for (int keys in columnNames.keys)
      map[columnNames[keys][0]] = task.getTaskInfo(keys)?.toString();

    if (mode) map.remove(columnNames[7][0]);

    return map;
  }

  static TaskEntity fromMap(Map<String, dynamic> map) => TaskEntity(
        name: map[columnNames[0][0]],
        dueDate: _convertDate(map[columnNames[1][0]]),
        description: map[columnNames[2][0]],
        priority: _convertInt(map[columnNames[3][0]]),
        difficulty: _convertInt(map[columnNames[4][0]]),
        location: map[columnNames[5][0]],
        completeDate: _convertDate(map[columnNames[6][0]]),
        setDate: _convertDate(map[columnNames[7][0]]),
      );

  String name;
  DateTime dueDate;
  DateTime completeDate;
  String description;
  int priority;
  int difficulty;
  String location;
  DateTime setDate;

  /// Constructor for class.
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

  /// Method for getting any information about a task by passing in an index that represents the task.
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
