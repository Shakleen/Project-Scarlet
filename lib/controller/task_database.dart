import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../entities/task_entity.dart';

/// [TaskDatabase] class is responsible for storing and manipulating
///  task information in the database.
///
/// The methods [insertTask], [removeTask], [updateTask] are responsible
/// for manipulating task information. The [_database] object is used
/// to create and interact with the sqlite database.
class TaskDatabase {
  static final TaskDatabase taskDatabase = TaskDatabase._();
  static Database _database;
  static final List<String> whereClauses = const [
    " >= ?",
    " < ?",
  ];

  /// Private constructor of TaskDatabase class.
  TaskDatabase._();

  /// Public method for initializing the database.
  Future<void> initializeDatabase() async {
    // Checking to see if the [_database] object is null.
    if (_database == null) {
      // We will call [initDatabase] method to initialize [_database]
      // with a new Database type object.
      print('TaskDatabase - initializeDatabase - '); // TODO REMOVE THIS

      try {
        _database = await _initDatabase();
        print('Database created!'); // TODO REMOVE THIS
      } catch (e) {
        // TODO IMPLEMENT EXCEPTION HANDLING
        print('Problem creating database!'); // TODO REMOVE THIS
      }
    }

    return;
  }

  /// Public method for creating the necessary views of the database main table.
  Future<void> createViews() async {
    print("TaskDatabase - createviews - ");
    try {
      await _database.execute(_buildTableViewCreateStatement(0));
      await _database.execute(_buildTableViewCreateStatement(1));

      print('Views created successfully!');
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
      print("Views couldn't be created! " + e.toString()); // TODO REMOVE THIS
    }
  }

  /// Public method for inserting a new task into the database.
  Future<int> insertTask(TaskEntity task) async {
    print('TaskDatabase - insertTask - ');
    try {
      final int result = await _database.insert(
        TaskEntity.tableName,
        TaskEntity.toMap(task, false),
      );

      if (result == 1) {
        print('Successful insertion!'); // TODO REMOVE THIS
        return getTaskCount();
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
      print('failed insertion!' + e.toString()); // TODO REMOVE THIS
    }
    return getTaskCount();
  }

  /// Public method for removing an existing task from the database.
  Future<int> removeTask(TaskEntity task) async {
    print('TaskDatabase - removeTask - '); // TODO REMOVE THIS

    try {
      final int result = await _database.delete(
        TaskEntity.tableName,
        where: (TaskEntity.columnNames[7][0] + " = ?"),
        whereArgs: [task.setDate.toString()],
      );
      if (result == 1) {
        print('removal successful!'); // TODO REMOVE THIS
        return getTaskCount();
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
      print('exception occured!'); // TODO REMOVE THIS
    }

    print('removal failed!'); // TODO REMOVE THIS
    return getTaskCount();
  }

  /// Public method for updating existing task information.
  Future<int> updateTask(TaskEntity task) async {
    print('TaskDatabase - updateTaske - '); // TODO REMOVE THIS

    try {
      Map<String, dynamic> myMap = TaskEntity.toMap(task, true);
      print(myMap);
      final int result = await _database.update(
        TaskEntity.tableName,
        myMap,
        where: TaskEntity.columnNames[7][0] + " = ?",
        whereArgs: [task.setDate.toString()],
      );

      print('Result of update: ' + result?.toString());

      if (result == 1) {
        print('Update successful!'); // TODO REMOVE THIS
        return getTaskCount();
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
      print('Exception occured!'); // TODO REMOVE THIS
      print(e);
    }

    print('Update failed!'); // TODO REMOVE THIS

    return getTaskCount();
  }

  Future<int> getTaskCount() async {
    final List<dynamic> result = await _database
        .rawQuery("SELECT COUNT(SETDATE) FROM " + TaskEntity.tableName);
    print(result[0]['COUNT(SETDATE)']);
    return result[0]['COUNT(SETDATE)'];
  }

  /// Public method for retrieving tasks of three types. Type is
  /// specified by [type]. The 3 types are:
  /// Type 1: Upcoming tasks. No complete date and due
  /// date is after current date.
  /// Type 2: Overdue tasks. No complete date and due date
  /// is before current date.
  /// Type 3: Completed tasks. Has complete date.
  Future<List<TaskEntity>> getTasks(int type) async {
    print('TaskDatabase - getTasks - '); // TODO REMOVE THIS
    final List<TaskEntity> resultList = [];

    try {
      List<Map<String, dynamic>> result;
      switch (type) {
        case 1: // Upcoming
        case 2: // Overdue
          result = await _database.query(
            TaskEntity.tableViewNames[0],
            where: TaskEntity.columnNames[1][0] + whereClauses[type - 1],
            whereArgs: [DateTime.now().toString()],
            orderBy: TaskEntity.columnNames[1][0],
          );
          break;
        case 3: // Completed
          result = await _database.query(
            TaskEntity.tableViewNames[1],
            orderBy: TaskEntity.columnNames[1][0],
          );
          break;
        default: // All
          result = await _database.query(
            TaskEntity.tableName,
            orderBy: TaskEntity.columnNames[1][0],
          );
          break;
      }

      print("Length = " + result?.length.toString()); // TODO REMOVE THIS

      if (result != null) {
        for (Map<String, dynamic> entry in result)
          resultList.add(TaskEntity.fromMap(entry));

        print("Length of the list is " +
            resultList.length.toString()); // TODO REMOVE THIS
      }
    } catch (e) {
      // TODO IMPLEMENT EXCEPTION HANDLING
      print('Exception occured!' + e.toString()); // TODO REMOVE THIS
    }

    return resultList;
  }

  /// Private method for handling the creation or retrieval of a database from
  /// the appropriate database file.
  Future<Database> _initDatabase() async {
    // Get directory and file path
    final Directory documentsDirectory =
        await getApplicationDocumentsDirectory();
    final String path =
        join(documentsDirectory.path, TaskEntity.databaseFileName);

    // Open database file and create a table if it doesn't exist.
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(_buildTableCreateStatement());
      },
    );
  }

  /// Private method for building the table which will contain all the task related
  /// information.
  String _buildTableCreateStatement() {
    final int numberOfColumns = TaskEntity.columnNames.length - 1;
    String statement = "CREATE TABLE " + TaskEntity.tableName + " (";

    // Creating the column name and column type portion
    for (int i = 0; i <= numberOfColumns; ++i)
      statement += TaskEntity.columnNames[i][0] +
          " " +
          TaskEntity.columnNames[i][1] +
          (i < numberOfColumns
              ? ", "
              : ", CONSTRAINT TASKS_PRIMARY_KEY PRIMARY KEY(SetDate))");

    print('TaskDatabase - _buildTableCreateStatement - ' +
        statement); // TODO REMOVE THIS

    return statement;
  }

  /// Private method for creating views of the table.
  String _buildTableViewCreateStatement(int view) {
    String statement =
        "CREATE VIEW " + TaskEntity.tableViewNames[view] + " AS SELECT ";
    final String ending = " FROM " +
        TaskEntity.tableName +
        " WHERE " +
        TaskEntity.columnNames[6][0] +
        " is" +
        (view == 1 ? " NOT NULL" : " NULL");
    final len = TaskEntity.columnNames.length - 1;

    for (int i = 0; i <= len; ++i)
      statement += TaskEntity.columnNames[i][0] + (i < len ? ", " : ending);

    print(statement); // TODO REMOVE THIS

    return statement;
  }
}
