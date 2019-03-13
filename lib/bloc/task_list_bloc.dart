import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/entities/task_entity.dart';

class TaskListBloc implements BlocBase {
  final void Function(TaskEntity task, bool status) removeTask,
      completeTask,
      updateTask,
      addTask;
  final int tabType;

  TaskListBloc({
    this.tabType,
    this.updateTask,
    this.removeTask,
    this.completeTask,
    this.addTask,
  });

  @override
  void dispose() {}
}
