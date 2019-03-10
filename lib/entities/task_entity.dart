import 'package:flutter/material.dart';

import '../presentation/custom_icons.dart';

/// Entity class for tasks.
class TaskEntity {
  String name, description, location;
  int id, priority, difficulty;
  DateTime dueDate, completeDate, setDate;

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
      ..id = id;
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
      default:
        return null;
    }
  }
}

DateTime convertDate(dynamic input) => input != null
    ? input.runtimeType.toString() == 'DateTime' ? input : DateTime.parse(input)
    : null;

int convertInt(dynamic input) =>
    input != null ? input.runtimeType == int ? input : int.parse(input) : null;

Map<String, dynamic> toMap(TaskEntity task) {
  final Map<String, dynamic> map = {};
//  print('TaskEntity toMap');
  for (int key in columnData.keys) {
    final String value = task.getTaskInfo(key)?.toString(),
        column = columnData[key][0];
//    print('$column = $value');
    map[column] = value;
  }

  map.remove(primaryKey);

  return map;
}

final Map<int, List<dynamic>> priorityData = const {
  0: ['Low', CustomIcons.low, Colors.black],
  1: ['Normal', CustomIcons.normal, Colors.green],
  2: ['Important', CustomIcons.important, Colors.purple],
  3: ['Urgent', CustomIcons.urgent, Colors.red],
},
    difficultyData = const {
  0: ['Easy', CustomIcons.low, Colors.black],
  1: ['Medium', CustomIcons.normal, Colors.green],
  2: ['Difficult', CustomIcons.important, Colors.purple],
  3: ['Hard', CustomIcons.urgent, Colors.red],
},
    columnData = const {
  0: ["Name", "TEXT", "NOT NULL"],
  1: ["DueDate", "DATETIME", "NOT NULL"],
  2: ["Description", "TEXT", "DEFAULT NULL"],
  3: ["Priority", "INTEGER", "DEFAULT 0"],
  4: ["Difficulty", "INTEGER", "DEFAULT 0"],
  5: ["Location", "TEXT", "DEFAULT NULL"],
  6: ["CompleteDate", "DATETIME", "DEFAULT NULL"],
  7: ["SetDate", "DATETIME", "NOT NULL"],
  8: ["ID", "INTEGER", "PRIMARY KEY AUTOINCREMENT"],
};
final Map<String, dynamic> taskFormData = {
  columnData[0][0]: null, // Name
  columnData[1][0]: DateTime.now(), // Due Date
  columnData[2][0]: null, // Description
  columnData[3][0]: 0, // Priority
  columnData[4][0]: 0, // Difficulty
  columnData[5][0]: null, // Location
  columnData[7][0]: DateTime.now(), // Set date
  columnData[8][0]: 0, // ID
};
final String primaryKey = columnData[8][0],
    taskTableName = "Tasks",
    taskDatabaseFileName = "TasksDatabase.db";
final List<String> taskTableViewNames = const [
  "TasksPending",
  "TasksCompleted"
];

TaskEntity fromMap(Map<String, dynamic> map) {
  if (map.keys.contains(columnData[4][0])) {
    return TaskEntity(
      name: map[columnData[0][0]],
      dueDate: convertDate(map[columnData[1][0]]),
      description: map[columnData[2][0]],
      priority: convertInt(map[columnData[3][0]]),
      difficulty: convertInt(map[columnData[4][0]]),
      location: map[columnData[5][0]],
      setDate: convertDate(map[columnData[7][0]]),
      completeDate: convertDate(map[columnData[6][0]]),
    );
  }
  return TaskEntity(
    name: map[columnData[0][0]],
    dueDate: convertDate(map[columnData[1][0]]),
    priority: convertInt(map[columnData[3][0]]),
    setDate: convertDate(map[columnData[7][0]]),
    completeDate: convertDate(map[columnData[6][0]]),
  );
}
