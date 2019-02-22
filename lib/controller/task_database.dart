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
      print("From createDatabase:\n");
      print(_database);
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

    print(statement);

    return statement;
  }

  Future<bool> insertTask(TaskEntity task) async {
    final int result =
        await _database.insert(_tableName, TaskModel.toMap(task));
    if (result == 1) {
      print('Successful insertion!');
      return true;
    }
    return false;
  }

  Future<bool> updateTask(TaskEntity task) async {
    final int result = await _database.update(
      _tableName,
      TaskModel.toMap(task),
    );
    return result == 1 ? true : false;
  }

  Future<List<TaskEntity>> getTask(String uuid) async {
    List<Map<String, dynamic>> result;
    
    if (uuid != null) {
      result = await _database.query(_tableName,
          where: TaskModel.columnNames[0][0] + " = ?", whereArgs: [uuid]);
    } else {
      result = await _database.query(_tableName);
    }

    if (result != null) {
      print('TaskDatabase - getTask\n');
      final List<TaskEntity> resultList = [];

      for (Map<String, dynamic> entry in result) {
        final TaskEntity taskEntity = TaskEntity(
          id: entry[TaskModel.columnNames[0][0]],
          name: entry[TaskModel.columnNames[1][0]],
          dueDate: DateTime.parse(entry[TaskModel.columnNames[2][0]]),
          description: entry[TaskModel.columnNames[3][0]],
          priority: entry[TaskModel.columnNames[4][0]],
          location: entry[TaskModel.columnNames[5][0]],
        );
        taskEntity.setSetDate(DateTime.parse(entry[TaskModel.columnNames[7][0]]));
        final String completeDate = entry[TaskModel.columnNames[6][0]];
        taskEntity.setCompleteDate(completeDate == null ? null : DateTime.parse(completeDate));
        resultList.add(taskEntity);
      }

      print(resultList.length);

      return resultList;
    }
  }
}
