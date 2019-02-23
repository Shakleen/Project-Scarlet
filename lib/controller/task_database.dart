import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../entities/task_entity.dart';

/// A backend class that handles the database data storage of the
/// tasks the user saves.
///
/// The class employs methods for storing, receiving, changing and
/// removing data related to tasks. It can be accessed through only
/// [taskDatabase] object. As the constructor is private no other
/// object of this class will exist. It employs a single access point
/// across the entire application.
class TaskDatabase {
  static final TaskDatabase taskDatabase = TaskDatabase._();
  static Database _database;
  static final String _tableName = "Tasks";
  static final List<String> _tableViewNames = [
    "TasksPending",
    "TasksCompleted",
  ];
  static final String _databaseFileName = "TasksDatabase.db";
  static final Map<int, dynamic> columnNames = const {
    0: ["UUID", "Text"],
    1: ["Name", "Text"],
    2: ["DueDate", "DateTime"],
    3: ["Description", "Text"],
    4: ["Priority", "Number"],
    5: ["Location", "Text"],
    6: ["CompleteDate", "DateTime"],
    7: ["SetDate", "DateTime"]
  };

  /// Private constructor of TaskDatabase class.
  TaskDatabase._();

  /// Method for initializing the database.
  ///
  /// First it checks to see if [_database] is null. If it is null
  /// then it calls [_initDatabase] method to get a database object
  /// and assigns to [_database].
  /// However if the [_database] object is not null then the method
  /// does nothing and simple returns.
  ///
  /// Caution, the databse might take sometime to load and initialize.
  /// So it is advised that it is called at the very start of the
  /// application so that by the time the user does something that
  /// requires the database it will be up and running.
  Future<void> initializeDatabase() async {
    // Checking to see if the [_database] object is null.
    if (_database == null) {
      // We will call [initDatabase] method to initialize [_database]
      // with a new Database type object.
      _database = await _initDatabase();
      print('Database created!'); // TODO REMOVE THIS
    }

    return;
  }

  /// Method for creating the necessary views of the database main table.
  ///
  /// The views are used to efficiently access things off the table.
  /// There are mainly 2 views. One for completed and one for pending tasks.
  Future<void> createViews() async {
    try {
      await _database.execute(_buildTableViewCreateStatement(0));
      await _database.execute(_buildTableViewCreateStatement(1));
    } catch (e) {
      print("TaskDatabase - createviews - Print exception caught!"); // TODO REMOVE THIS
    }
  }

  /// Method for handling the creation or retrieval of a database from
  /// the appropriate database file.
  ///
  /// This method first gets the path where the application stores files.
  /// Then it checks to see if there is a database file of the name
  /// [_databaseFileName] in the directory. If there is one, or tries to
  /// open the file. Otherwise it creates te file and then opens it.
  Future<Database> _initDatabase() async {
    // Get directory and file path
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, _databaseFileName);

    // Open databse file and create a table if it doesn't exist.
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(_buildTableCreateStatement());
      },
    );
  }

  /// Helper method for building the table which will contain all the task related
  /// information. This table named [_tableName] will be the main table.
  /// The column names and types of this table are kept in the map variable
  /// [columnNames]
  String _buildTableCreateStatement() {
    String statement = "CREATE TABLE " + _tableName + "(";
    final int len = columnNames.length - 1;

    for (int i = 0; i <= len; ++i) {
      statement += columnNames[i][0] + " " + columnNames[i][1] + (i < len)
          ? ", "
          : ", CONSTRAINT PK_UUID PRIMARY KEY(" + columnNames[0][0] + "))";
    }

    print(statement); // TODO REMOVE THIS

    return statement;
  }

  /// Helper method for creating views of the table. The view names are
  /// specified in the [_tableViewNames] list.
  String _buildTableViewCreateStatement(int view) {
    String statement =
        "CREATE VIEW " + _tableViewNames[view] + " AS SELECT ";
    final String ending = " FROM " +
        _tableName +
        " WHERE " +
        columnNames[6][0] +
        " is" +
        ((view == 1) ? " not Null" : " Null");
    final len = 2;

    for (int i = 0; i <= len; ++i) {
      statement += columnNames[i][0] + (i < len ? ", " : ending);
    }

    print(statement); // TODO REMOVE THIS

    return statement;
  }

  /// Method for inserting a new task into the database. The method takes the
  /// information stored in [task] object and first creates a sql statement
  /// by calling the helper method [_insertQueryBuilder] and then executes the
  /// sql statement.
  Future<bool> insertTask(TaskEntity task) async {
    final int result = await _database.rawInsert(_insertQueryBuilder(task));

    if (result == 1) {
      print('Successful insertion!'); // TODO REMOVE THIS
      return true;
    }
    return false;
  }

  /// Helper method for building the sql statement for inserting a
  /// new task.
  String _insertQueryBuilder(TaskEntity task) {
    String statement = "INSERT INTO " + _tableName + " (";
    String values = " VALUES (";
    final int len = columnNames.length - 1;

    for (int i = 0; i <= len; ++i) {
      statement += columnNames[i][0] + ((i < len) ? ", " : ") ");
      values += _buildValueFragment(task, i) + ((i < len) ? ", " : ") ");
    }

    print(statement + values); // TODO REMOVE THIS

    return statement + values;
  }

  /// Helper method for building sql statement for inserting information.
  String _buildValueFragment(TaskEntity task, int i) {
    if (columnNames[i][1] == "Number") {
      return task.getInfo(i).toString();
    } else if (columnNames[i][1] == "Text") {
      return "'" + task.getInfo(i).toString() + "'";
    } else if (columnNames[i][1] == "DateTime" && task.getInfo(i) != null) {
      final DateTime dateTime = task.getInfo(i);
      return "datetime('" + dateTime.toString() + "')";
    } else {
      return 'Null';
    }
  }

  /// Method for removing an existing task from the database.
  /// Task identified by [uuid].
  Future<void> removeTask(String uuid) async {
    String where = columnNames[0][0] + " = ?";
    final int result =
        await _database.delete(_tableName, where: where, whereArgs: [uuid]);
    return result == 1 ? true : false;
  }

  /// Method for updating existing task information which is identified
  /// by [uuid] and task information passed in as [task].
  Future<void> updateTask(TaskEntity task, String uuid) async {
    String statement = "UPDATE " + _tableName + " SET ";
    final String whereClause =
        " WHERE " + columnNames[0][0] + " = '" + uuid + "'";
    final int len = columnNames.length - 1;

    for (int i = 0; i <= len; ++i) {
      statement += columnNames[i][0] + " = " + _buildValueFragment(task, i) +
          (i < len ? ", " : whereClause);
    }

    final int result = await _database.rawUpdate(statement);

    return result == 1 ? true : false;
  }

  /// Method for returning a single task that is identified by
  /// [uuid].
  Future<TaskEntity> getTask(String uuid) async {
    final String statement = _queryStatementBuilder(4, uuid: uuid);
    print(statement);  // TODO REMOVE THIS
    List<Map<String, dynamic>> result = await _database.rawQuery(statement);
    return _parseTaskEntity(result[0], true);
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

    print("Result after rawQuery: Length = " +
        result?.length.toString()); // TODO REMOVE THIS

    if (result != null) {
      for (Map<String, dynamic> entry in result) {
        resultList.add(_parseTaskEntity(entry, false));
      }

      print("Length of the list is " +
          resultList.length.toString()); // TODO REMOVE THIS
    }

    return resultList;
  }

  /// Method for building the query statement.
  String _queryStatementBuilder(int type, {String uuid}) {
    String statement = "SELECT * FROM ";

    switch (type) {
      case 1: // Upcoming tasks
        statement +=  _tableViewNames[0] + " WHERE " +
            columnNames[2][0] +
            " >= " +
            "datetime('" +
            DateTime.now().toString() +
            "') " +
            "ORDER BY " +
            columnNames[2][0] +
            " ASC";
        break;
      case 2: // Overdue tasks
        statement +=  _tableViewNames[0] + " WHERE " +
            columnNames[2][0] +
            " < " +
            "datetime('" +
            DateTime.now().toString() +
            "') " +
            "ORDER BY " +
            columnNames[2][0] +
            " ASC";
        break;
      case 3: // Completed tasks
        statement +=  _tableViewNames[1] +
            " ORDER BY " +
            columnNames[2][0] +
            " ASC";
        break;
      case 4: // Get specific task
        statement += _tableName + " WHERE " + columnNames[0][0] + " = '" + uuid + "'";
        break;
    }

    print("Statement to execute : " + statement); // TODO REMOVE THIS

    return statement;
  }

  /// Method to parse and create a TaskEntity type object from
  /// the map type object [input].
  TaskEntity _parseTaskEntity(Map<String, dynamic> input, bool mode) {
    final String id = input[columnNames[0][0]];
    final String name = input[columnNames[1][0]];
    final String dueDate = input[columnNames[2][0]];

    final TaskEntity taskEntity = TaskEntity(
        id: id,
        name: name,
        dueDate: DateTime.parse(dueDate)
    );

    // True means everything should be parsed.
    if (mode) {
      final String description = input[columnNames[3][0]];
      final String priority = input[columnNames[4][0]]?.toString();
      final String location = input[columnNames[5][0]];
      final String completeDate = input[columnNames[6][0]];
      final String setDate = input[columnNames[7][0]];

      taskEntity.setDescription(description);
      taskEntity.setPriority(int.parse(priority));
      taskEntity.setLocation(location);
      taskEntity.setSetDate(DateTime.parse(setDate));
      taskEntity.setCompleteDate(
        completeDate == null ? null : DateTime.parse(completeDate),
      );
    }

    return taskEntity;
  }
}

/**
 * no such column: d3e77ef0 (code 1 SQLITE_ERROR): , while compiling: UPDATE Tasks SET UUID = 'd3e77ef0-3260-11e9-d97a-fbb6eb4807da', Name = 'Swimming', DueDate = datetime('2019-02-23 22:56:00.000'), Description = 'null', Priority = 2, Location = 'null', CompleteDate = datetime('2019-02-23 16:23:10.248770'), SetDate = datetime('2019-02-22 22:56:41.000') WHERE UUID = d3e77ef0-3260-11e9-d97a-fbb6eb4807da
 */
