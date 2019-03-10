import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:sqflite/sqflite.dart';

/// [TaskDatabase] class is responsible for storing and manipulating
///  task information in the database.
class TaskDatabase {
  static final TaskDatabase taskDatabase = TaskDatabase._();
  Database _database;
  final List<String> whereClauses = const [" >= ?", " < ?"];

  /// Private constructor of TaskDatabase class.
  TaskDatabase._();

  /// Public method for initializing the database.
  Future<void> initializeDatabase() async {
//    final String debug = 'TaskDatabase - initializeDatabase -';// TODO DEBUG PRINTS
    if (_database == null) {
      try {
        _database = await _initDatabase();
//         print('$debug Database created!'); // TODO DEBUG PRINTS
      } catch (e) {
        // TODO IMPLEMENT EXCEPTION HANDLING
//         print('$debug Problem creating database!\n$e'); // TODO DEBUG PRINTS
      }
    }

    return;
  }

  /// Public method for creating the necessary views of the database main table.
  Future<void> createViews() async {
//     final String debug = "TaskDatabase - createviews -"; // TODO DEBUG PRINTS
    try {
      await _database.execute(_buildTableViewCreateStatement(0));
      await _database.execute(_buildTableViewCreateStatement(1));

//       print('$debug Views created successfully!');// TODO DEBUG PRINTS
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
//       print("$debug Views couldn't be created!\n$e"); // TODO DEBUG PRINTS
    }
  }

  /// Public method for inserting a new task into the database.
  Future<bool> insertTask(TaskEntity task) async {
//     final String debug = 'TaskDatabase - insertTask -'; // TODO DEBUG PRINTS
    try {
      final int result = await _database.insert(taskTableName, toMap(task));

      if (result != 0) {
//         print('$debug Successful insertion!'); // TODO DEBUG PRINTS
        return true;
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
//       print('$debug failed insertion! $e'); // TODO DEBUG PRINTS
    }
    return false;
  }

  /// Public method for removing an existing task from the database.
  Future<bool> removeTask(TaskEntity task) async {
//     final String debug = 'TaskDatabase - removeTask -'; // TODO DEBUG PRINTS

    try {
      final int result = await _database.delete(taskTableName,
          where: "$primaryKey = ${task.id}");
      if (result != 0) {
//         print('$debug removal successful!'); // TODO DEBUG PRINTS
        return true;
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
//       print('$debug exception occured! $e'); // TODO DEBUG PRINTS
    }

//     print('$debug removal failed!'); // TODO DEBUG PRINTS
    return false;
  }

  /// Public method for updating existing task information.
  Future<bool> updateTask(TaskEntity task) async {
//     final String debug = 'TaskDatabase - updateTaske -'; // TODO DEBUG PRINTS

    try {
      Map<String, dynamic> myMap = toMap(task);
//       print(myMap); // TODO DEBUG PRINTS
      final int result = await _database.update(
        taskTableName,
        myMap,
        where: "${columnData[7][0]} = ?",
        whereArgs: [task.setDate.toString()],
      );

//       print('$debug Result of update: $result');// TODO DEBUG PRINTS

      if (result != 0) {
//         print('$debug Update successful!'); // TODO DEBUG PRINTS
        return true;
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
//       print('$debug Exception occured! $e'); // TODO DEBUG PRINTS
    }

//     print('$debug Update failed!'); // TODO DEBUG PRINTS
    return false;
  }

  // Returns information of a single task
  Future<TaskEntity> getTaskDetails(TaskEntity task) async {
//    final debug = 'TaskDatabase - getTaskDetals -';// TODO DEBUG PRINTS
//    print('$debug task ${task.name} set date is ${task.setDate}');// TODO DEBUG PRINTS
    final List<dynamic> result = await _database.query(
      taskTableName,
      where: '${columnData[7][0]} = ?',
      whereArgs: [task.setDate.toString()],
    );
//    print('$debug result set is $result');// TODO DEBUG PRINTS
    return fromMap(result[0]);
  }

  /// Public method for retrieving tasks of three types. Type is
  /// specified by [type]. The 3 types are:
  /// Type 1: Upcoming tasks. No complete date and due
  /// date is after current date.
  /// Type 2: Overdue tasks. No complete date and due date
  /// is before current date.
  /// Type 3: Completed tasks. Has complete date.
  Future<List<TaskEntity>> getTasksByOffset(
      {int type, int offset, int limit}) async {
//     final debug = 'TaskDatabase - getTasksByOffSet -'; // TODO DEBUG PRINTS
    final List<TaskEntity> resultList = [];

    try {
      List<Map<String, dynamic>> result;
      switch (type) {
        case 1: // Upcoming
        case 2: // Overdue
          result = await _database.query(
            taskTableViewNames[0],
            where: '${columnData[1][0]} ${whereClauses[type - 1]}',
            whereArgs: [DateTime.now().toString()],
            orderBy: columnData[1][0],
            limit: limit,
            offset: offset,
          );
          break;
        case 3: // Completed
          result = await _database.query(
            taskTableViewNames[1],
            orderBy: columnData[1][0],
            limit: limit,
            offset: offset,
          );
          break;
        default: // All
          result = await _database.query(
            taskTableName,
            orderBy: columnData[1][0],
            limit: limit,
            offset: offset,
          );
          break;
      }

//       print("$debug DBMS length = ${result.length}"); // TODO DEBUG PRINTS

      if (result != null) {
        for (Map<String, dynamic> entry in result)
          resultList.add(fromMap(entry));

//         print("$debug parsed length ${resultList.length}"); // TODO DEBUG PRINTS
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
//       print('$debug Exception occured!\n$e'); // TODO DEBUG PRINTS
    }

    return resultList;
  }

  /// Private method for handling the creation or retrieval of a database from
  /// the appropriate database file.
  Future<Database> _initDatabase() async {
    // Get directory and file path
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, taskDatabaseFileName);

    // Open database file and create a table if it doesn't exist.
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute(_buildTableCreateStatement());
    });
  }

  /// Private method for building the table which will contain all the task related
  /// information.
  String _buildTableCreateStatement() {
    final int numberOfColumns = columnData.length - 1;
    String statement = "CREATE TABLE $taskTableName (";

    // Creating the column name and column type portion
    for (int i = 0; i <= numberOfColumns; ++i)
      statement +=
          "${columnData[i][0]} ${columnData[i][1]} ${columnData[i][2]}" +
              (i < numberOfColumns ? ", " : ")");

//     print('TaskDatabase - _buildTableCreateStatement - ' + statement); // TODO DEBUG PRINTS

    return statement;
  }

  /// Private method for creating views of the table.
  String _buildTableViewCreateStatement(int view) {
    String statement = "CREATE VIEW ${taskTableViewNames[view]} AS SELECT ";
    final String ending = " FROM $taskTableName WHERE ${columnData[6][0]} is " +
        (view == 1 ? "NOT NULL" : "NULL");
    final List<String> columns = [
      "Name",
      "DueDate",
      "Priority",
      "CompleteDate",
      "SetDate",
      "ID"
    ];
    final len = columns.length - 1;

    for (int i = 0; i <= len; ++i)
      statement += columns[i] + (i < len ? ", " : ending);

//     print(statement); // TODO DEBUG PRINTS

    return statement;
  }
}
