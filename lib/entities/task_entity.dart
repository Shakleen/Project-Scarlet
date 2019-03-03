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
    0: ["Name", "TEXT", "NOT NULL"],
    1: ["DueDate", "DATETIME", "NOT NULL"],
    2: ["Description", "TEXT", "DEFAULT NULL"],
    3: ["Priority", "INTEGER", "DEFAULT 0"],
    4: ["Difficulty", "INTEGER", "DEFAULT 0"],
    5: ["Location", "TEXT", "DEFAULT NULL"],
    6: ["CompleteDate", "DATETIME", "DEFAULT NULL"],
    7: ["SetDate", "DATETIME", "NOT NULL"],
    8: ["ID", "INTEGER", "PRIMARY KEY AUTOINCREMENT"],
    9: ["YEARLY", "BOOLEAN", "DEFAULT FALSE"],
  };
  static final Map<String, dynamic> taskFormData = {
    TaskEntity.columnNames[0][0]: null, // Name
    TaskEntity.columnNames[1][0]: DateTime.now(), // Due Date
    TaskEntity.columnNames[2][0]: null, // Description
    TaskEntity.columnNames[3][0]: 0, // Priority
    TaskEntity.columnNames[4][0]: 0, // Difficulty
    TaskEntity.columnNames[5][0]: null, // Location
    TaskEntity.columnNames[7][0]: DateTime.now(), // Set date
    TaskEntity.columnNames[8][0]: 0, // ID
    TaskEntity.columnNames[9][0]: false, // Yearly
  };
  static final String primaryKey = columnNames[8][0],
      tableName = "Tasks",
      databaseFileName = "TasksDatabase.db";
  static final List<String> tableViewNames = const [
    "TasksPending",
    "TasksCompleted",
  ];

  String name, description, location;
  int id, priority, difficulty;
  DateTime dueDate, completeDate, setDate;
  bool yearly;

  /// Constructor for class.
  TaskEntity({
    @required String name,
    @required DateTime dueDate,
    DateTime setDate,
    DateTime completeDate,
    String description,
    String location,
    int priority = 0,
    int difficulty = 0,
    int id = 0,
    bool yearly = false,
  }) {
    this
      ..name = name
      ..dueDate = dueDate
      ..setDate = setDate == null ? DateTime.now() : setDate
      ..description = description
      ..priority = priority
      ..difficulty = difficulty
      ..location = location
      ..completeDate = completeDate
      ..id = id
      ..yearly = yearly;
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
      case 8:
        return this.id;
      case 9:
        return this.yearly;
      default:
        return null;
    }
  }

  static DateTime _convertDate(dynamic input) => input != null
      ? input.runtimeType.toString() == 'DateTime'
          ? input
          : DateTime.parse(input)
      : null;

  static int _convertInt(dynamic input) =>
      input.runtimeType == int ? input : int.parse(input);

  static bool _convertBool(dynamic input) => input.runtimeType == bool
      ? input
      : input.toString().toLowerCase() == 'false' ? false : true;

  static Map<String, dynamic> toMap(TaskEntity task, bool mode) {
    final Map<String, dynamic> map = {};

    for (int keys in columnNames.keys) 
      map[columnNames[keys][0]] = task.getTaskInfo(keys)?.toString();

    if (mode) map.remove(primaryKey);

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
        id: _convertInt(map[columnNames[8][0]]),
        yearly: _convertBool(map[columnNames[9][0]]),
      );
}
