import 'package:project_scarlet/entities/task_entity.dart';

class TaskOperation {
  final TaskEntity task;
  final Future<bool> Function(TaskEntity task) revertOperation;

  TaskOperation({
    this.task,
    this.revertOperation,
  });
}