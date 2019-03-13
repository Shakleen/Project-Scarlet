import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_database_bloc.dart';
import 'package:project_scarlet/bloc/task_list_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_card.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_dismiss_container.dart';

/// A class for creating a dismissible for a [task] depending on a specific [tabType].
///
/// The class implements a dismiss direction to complete a task. Depending on the [tabType]
/// the dismissible can be dragged either both ways horizontally or just to the left. Dragging
/// to the left deletes a task while dragging to the right completes it.
class TaskDismissible extends StatelessWidget {
  final TaskEntity task;

  TaskDismissible({
    Key key,
    @required this.task,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskDatabaseBloc taskBloc = BlocProvider.of<TaskDatabaseBloc>(
        context);
    final TaskListBloc taskListBloc = BlocProvider.of<TaskListBloc>(context);
    final DismissDirection direction = taskListBloc.tabType == 2
        ? DismissDirection.endToStart
        : DismissDirection.horizontal;

    return Dismissible(
      key: Key('${task.name} TaskDismissible'),
      // A task card is constructed for each of the tasks in taskList.
      child: TaskCard(task: task),

      // Green background shown when dragged to the right. Drag right for completing.
      background: TaskDismissContainer(
        key: ValueKey('${task.setDate} DismissContainer green'),
        color: Colors.green,
        icon: Icons.check,
        mainAxisAlignment: MainAxisAlignment.start,
      ),

      // Red background shown when dragged to the left. Drag right for deleting.
      secondaryBackground: TaskDismissContainer(
        key: ValueKey('${task.setDate} DismissContainer red'),
        color: Colors.red,
        icon: Icons.delete,
        mainAxisAlignment: MainAxisAlignment.end,
      ),

      // Allowable swipe directions.
      direction: direction,

      // Function to call based on which way swiped
      onDismissed: (DismissDirection direction) {
        if (direction == DismissDirection.endToStart) {
          taskListBloc.removeTask(task, true);
          taskBloc.deleteTask(task);
        } else {
          taskListBloc.completeTask(task, true);
          taskBloc.completeTask(task);
        }
      },
      dismissThresholds: {
        DismissDirection.endToStart: 0.9,
        DismissDirection.startToEnd: 0.9,
      },
    );
  }
}
