import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/strategy/bloc_provider.dart';
import 'package:project_scarlet/bloc/strategy/task_bloc.dart';
import 'package:project_scarlet/entities/task_entity.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_card.dart';

/// [TaskList] class is resposible for displaying the list of tasks
/// in a specific tab which is a stateful class.
class TaskList extends StatelessWidget {
  final int tabType;
  TaskBloc bloc;

  TaskList(this.tabType);

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<TaskBloc>(context);
    print('Task list builder called!');

    return StreamBuilder<List<TaskEntity>>(
      stream: bloc.getStream(tabType),
      builder:
          (BuildContext context, AsyncSnapshot<List<TaskEntity>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data.length > 0) return _buildListView(snapshot.data);
          return Container(height: 0.0, width: 0.0);
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }

  /// Method that builds the list of [TaskCard] type objects to display on the screen.
  ///
  /// Dismissible is used for dissmissing tasks. Swiping from end to start removes and
  /// from start to end completes a task. Dissmiss action is handled by [_handleOnDismiss]
  /// function.
  Widget _buildListView(List<TaskEntity> taskList) {
    return ListView.builder(
      itemCount: taskList.length,
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          child: TaskCard(task: taskList[index], tabType: tabType),
          background: _buildContainer(true),
          // For completion.
          secondaryBackground: _buildContainer(false),
          // For remove.
          key: Key(taskList[index].setDate.toString()),
          direction: tabType == 2 // Tab type = 2 means Completed tab
              ? DismissDirection.endToStart // Swipe to only delete
              : DismissDirection.horizontal,
          // Swipe to both complete and delete
          onDismissed: (DismissDirection direction) {
            if (direction == DismissDirection.endToStart)
              bloc.deleteTask(taskList[index]);
            else
              bloc.completeTask(taskList[index]);
          },
          dismissThresholds: {
            DismissDirection.endToStart: 0.9,
            DismissDirection.startToEnd: 0.9,
          },
        );
      },
    );
  }

  /// Method for building the container of the dissmissable widget.
  ///
  /// [mode] true means complete and false means remove.
  Widget _buildContainer(bool mode) {
    IconData icon;
    MainAxisAlignment mainAxisAlignment;
    Color color;

    if (mode) {
      color = Colors.green;
      icon = Icons.check;
      mainAxisAlignment = MainAxisAlignment.start;
    } else {
      color = Colors.red;
      icon = Icons.delete;
      mainAxisAlignment = MainAxisAlignment.end;
    }

    return Container(
      color: color,
      child: Row(
        children: <Widget>[Icon(icon, size: 35.0, color: Colors.white)],
        mainAxisAlignment: mainAxisAlignment,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0),
    );
  }
}
