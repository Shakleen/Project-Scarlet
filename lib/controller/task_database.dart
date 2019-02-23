import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../scoped_model/task_model.dart';
import '../entities/task_entity.dart';

class TaskDatabase {
  static final TaskDatabase taskDatabase = TaskDatabase._();

  static Database _database;
  static final String _tableName = TaskModel.tableName;
  static final String _databaseFileName = TaskModel.databaseFileName;

  TaskDatabase._();

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }

    _database = await initDatabase();
    return _database;
  }

  Future<void> createDatabase() async {
    if (_database == null) {
      _database = await initDatabase();
    }
  }

  initDatabase() async {
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseFileName);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(_buildCreateStatement());
      },
    );
  }

  String _buildCreateStatement() {
    String statement = "CREATE TABLE " + _tableName + "(";
    final Map<int, dynamic> columns = TaskModel.columnNames;

    for (int i = 0; i < columns.length; ++i) {
      statement += TaskModel.columnNames[i][0]; // Name of the column
      statement += " ";
      statement += TaskModel.columnNames[i][1]; // Type of the column

      if (i < columns.length - 1) {
        statement += ", ";
      } else {
        statement += ", CONSTRAINT PK_UUID PRIMARY KEY(" +
            TaskModel.columnNames[0][0] +
            "))";
      }
    }

    print(statement); // TODO REMOVE THIS

    return statement;
  }

  Future<bool> insertTask(TaskEntity task) async {
    final int result = await _database.rawInsert(_insertQueryBuilder(task));

    if (result == 1) {
      print('Successful insertion!'); // TODO REMOVE THIS
      return true;
    }
    return false;
  }

  String _insertQueryBuilder(TaskEntity task) {
    String statement = "INSERT INTO " + _tableName + " (";
    String values = " VALUES (";

    for (int i = 0; i < TaskModel.columnNames.length; ++i) {
      statement += TaskModel.columnNames[i][0];
      values += _buildValueFragment(task, i);

      if (i < TaskModel.columnNames.length - 1) {
        statement += ", ";
        values += ", ";
      } else {
        statement += ") ";
        values += ")";
      }
    }

    print(statement + values); // TODO REMOVE THIS

    return statement + values;
  }

  String _buildValueFragment(TaskEntity task, int i) {
    if (TaskModel.columnNames[i][1] == "Number") {
      return task.getInfo(i).toString();
    } else if (TaskModel.columnNames[i][1] == "Text") {
      return "'" + task.getInfo(i).toString() + "'";
    } else if (TaskModel.columnNames[i][1] == "DateTime" &&
        task.getInfo(i) != null) {
      DateTime dateTime = task.getInfo(i);
      return "datetime('" + dateTime.toString() + "')";
    } else {
      return 'Null';
    }
  }

  /// Method for deleting an existing task from the database.
  /// Task identified by [uuid].
  Future<void> removeTask(String uuid) async {
    String where = TaskModel.columnNames[0][0] + " = ?";
    final int result = await _database.delete(_tableName, where: where, whereArgs: [uuid]);
    return result == 1 ? true : false;
  }

  /// Method for updating eisting task information which is identified 
  /// by [uuid] and task information passed in as [task].
  Future<void> updateTask(TaskEntity task, String uuid) async {
    String statement = "UPDATE " + _tableName + " SET ";

    for (int i = 0; i < TaskModel.columnNames.length; ++i) {
      statement +=
          TaskModel.columnNames[i][0] + " = " + _buildValueFragment(task, i);

      if (i < TaskModel.columnNames.length - 1) {
        statement += ", ";
      } else {
        statement += " WHERE " + TaskModel.columnNames[0][0] + " = '" + uuid + "'";
      }
    }

    final int result = await _database.rawUpdate(statement);

    return result == 1 ? true : false;
  }

  /// Method for returning a single task that is identified by
  /// [uuid].
  Future<TaskEntity> getTask(String uuid) async {
    String statement = _queryStatementBuilder(4, uuid: uuid);
    List<Map<String, dynamic>> result = await _database.rawQuery(statement);
    return _parseTaskEntity(result[0]);
  }

  /// Method for retrieving tasks of three types. Type is
  /// specified by [type]. The 3 types are:
  /// Type 1: Upcoming tasks. No complete date and due
  /// date is after current date.
  /// Type 2: Overdue tasks. No complete date and due date
  /// is before current date.
  /// Type 3: Completed tasks. Has complete date.
  Future<List<TaskEntity>> getTasks(int type) async {
    List<Map<String, dynamic>> result;
    final List<TaskEntity> resultList = [];
    String statement = _queryStatementBuilder(type);

    result = await _database.rawQuery(statement);

    if (result != null) {
      for (Map<String, dynamic> entry in result) {
        resultList.add(_parseTaskEntity(entry));
      }

      print("Length of the list is " +
          resultList.length.toString()); // TODO REMOVE THIS
    }

    return resultList;
  }

  /// Method for building the query statement.
  String _queryStatementBuilder(int type, {String uuid}) {
    String statement = "SELECT * FROM " + _tableName + " WHERE ";

    switch (type) {
      case 1: // Upcoming tasks
        print(statement);
        statement += TaskModel.columnNames[6][0] +
            " is Null AND " +
            TaskModel.columnNames[2][0] +
            " >= " +
            "datetime('" +
            DateTime.now().toString() +
            "') " +
            "ORDER BY " +
            TaskModel.columnNames[2][0] +
            " ASC";
        break;
      case 2: // Overdue tasks
        statement += TaskModel.columnNames[6][0] +
            " is Null AND " +
            TaskModel.columnNames[2][0] +
            " < " +
            "datetime('" +
            DateTime.now().toString() +
            "') " +
            "ORDER BY " +
            TaskModel.columnNames[2][0] +
            " ASC";
        break;
      case 3: // Completed tasks
        statement += TaskModel.columnNames[6][0] +
            " is not Null "
            "ORDER BY " +
            TaskModel.columnNames[2][0] +
            " ASC";
        break;
      case 4: // Get specific task
        statement += TaskModel.columnNames[0][0] + " = " + uuid;
        break;
    }

    print("Statement to execute : " + statement); // TODO REMOVE THIS

    return statement;
  }

  /// Method to parse and create a TaskEntity type object from
  /// the map type object [input].
  TaskEntity _parseTaskEntity(Map<String, dynamic> input) {
    final String id = input[TaskModel.columnNames[0][0]];
    final String name = input[TaskModel.columnNames[1][0]];
    final String dueDate = input[TaskModel.columnNames[2][0]];
    final String description = input[TaskModel.columnNames[3][0]];
    final String priority = input[TaskModel.columnNames[4][0]]?.toString();
    final String location = input[TaskModel.columnNames[5][0]];
    final String completeDate = input[TaskModel.columnNames[6][0]];
    final String setDate = input[TaskModel.columnNames[7][0]];

    final TaskEntity taskEntity = TaskEntity(
      id: id,
      name: name,
      dueDate: DateTime.parse(dueDate),
      description: description,
      priority: int.parse(priority),
      location: location,
    );

    taskEntity.setSetDate(DateTime.parse(setDate));

    taskEntity.setCompleteDate(
      completeDate == null ? null : DateTime.parse(completeDate),
    );

    return taskEntity;
  }
}

/**
 * no such column: d3e77ef0 (code 1 SQLITE_ERROR): , while compiling: UPDATE Tasks SET UUID = 'd3e77ef0-3260-11e9-d97a-fbb6eb4807da', Name = 'Swimming', DueDate = datetime('2019-02-23 22:56:00.000'), Description = 'null', Priority = 2, Location = 'null', CompleteDate = datetime('2019-02-23 16:23:10.248770'), SetDate = datetime('2019-02-22 22:56:41.000') WHERE UUID = d3e77ef0-3260-11e9-d97a-fbb6eb4807da
 */