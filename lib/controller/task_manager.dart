import 'package:project_scarlet/entities/task_operation.dart';

class TaskManager {
  List<TaskOperation> _taskStack = [];
  static TaskManager taskManager = TaskManager._();

  TaskManager._();

  bool get nonEmpty => _taskStack.isNotEmpty;

  void addOperation(TaskOperation taskOperation) => _taskStack.add(taskOperation);

  Future<bool> undoOperation() {
    Future<bool> result;

    if (_taskStack.isNotEmpty) {
      TaskOperation taskOp = _taskStack.last;
      result = taskOp.revertOperation(taskOp.task).then((bool status) {
        if (status) _taskStack.removeLast();
        return status;
      });
    }

    return result;
  }
}
