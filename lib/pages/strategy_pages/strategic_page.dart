import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../widgets/ui_elements/side_drawer.dart';
import '../../widgets/strategy_widgets/task_list.dart';
import '../../scoped_model/main_model.dart';

/// [StrategicPage] class is the main strategic page which consists of 3 tab bars.
class StrategicPage extends StatelessWidget {
  Function _addTask,
      _removeTask,
      _completeTask,
      _updateTask,
      _getUpcomingTaskList,
      _getOverdueTaskList,
      _getCompletedTaskList;

  StrategicPage();

  Widget _buildTab(bool mode, int tabNumber, BuildContext context) {
    String _text;
    IconData _icon;
    Function _function;

    if (tabNumber == 0) {
      _text = 'Upcoming';
      _icon = Icons.event_note;
      _function = _getUpcomingTaskList;
    } else if (tabNumber == 1) {
      _text = 'Overdue';
      _icon = Icons.event_busy;
      _function = _getOverdueTaskList;
    } else if (tabNumber == 2) {
      _text = 'Completed';
      _icon = Icons.event_available;
      _function = _getCompletedTaskList;
    }

    if (mode)
      return Tab(
        icon: Icon(_icon),
        text: _text,
      );

    return TaskList(tabNumber, _function, _addTask, _removeTask, _completeTask,
        _updateTask);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        _addTask = model.addTask;
        _removeTask = model.removeTask;
        _completeTask = model.completeTask;
        _updateTask = model.updateTask;
        _getUpcomingTaskList = model.getUpcomingTaskList;
        _getOverdueTaskList = model.getOverdueTaskList;
        _getCompletedTaskList = model.getCompletedTaskList;
        final List<Widget> _tabs = [], _tabbarViews = [];
        Text _text =
            Text('Strategic', style: Theme.of(context).textTheme.title);

        for (int i = 0; i <= 2; ++i) {
          _tabs.add(_buildTab(true, i, context));
          _tabbarViews.add(_buildTab(false, i, context));
        }

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: SideDrawer(4),
            appBar: AppBar(title: _text, bottom: TabBar(tabs: _tabs)),
            body: TabBarView(children: _tabbarViews),
          ),
        );
      },
    );
  }
}
