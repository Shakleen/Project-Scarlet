import '../entities/task_entity.dart';

class TaskOperation {
  final TaskEntity beforeValue, afterValue;
  final Future<bool> Function(TaskEntity, {bool mode}) perform, revert;
  final int type;

  TaskOperation(
      {this.beforeValue,
      this.afterValue,
      this.type,
      this.perform,
      this.revert});
}

class TaskStack {
  TaskStack._();

  static TaskStack taskStack = TaskStack._();
  static List<TaskOperation> _undoStack = [], _redoStack = [];

  void addOperation(TaskOperation operation) {
    _undoStack.add(operation);
    _redoStack.clear();
  }

  void undoOperation() {
    if (_undoStack.length > 0) {
      final TaskOperation taskOperation = _undoStack.last;
      taskOperation
          .revert(taskOperation.afterValue, mode: false)
          .then((bool status) {
        if (status) {
          _redoStack.add(_undoStack.last);
          _undoStack.removeLast();
        }
      });
    }
  }

  void redoOperation() {
    if (_redoStack.length > 0) {
      final TaskOperation taskOperation = _redoStack.last;
      taskOperation
          .perform(taskOperation.beforeValue, mode: false)
          .then((bool status) {
        if (status) {
          _undoStack.add(_redoStack.last);
          _redoStack.removeLast();
        }
      });
    }
  }
}
