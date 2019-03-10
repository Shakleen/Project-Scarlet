import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_bloc.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_form.dart';

/// A class for creating a Floating action button for the strategy page.
///
/// It calls the [_taskBloc.addTask] method when tapped. It gets the method
/// through the bloc provider.
class StrategyFAB extends StatelessWidget {
  StrategyFAB({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskBloc = BlocProvider.of<TaskBloc>(context);

    return FloatingActionButton(
      child: Icon(Icons.add, color: Theme.of(context).backgroundColor),
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TaskForm(
                        inputTask: null,
                        addTask: taskBloc.addTask,
                        updateTask: taskBloc.updateTask)));
      },
    );
  }
}
