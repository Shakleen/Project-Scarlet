import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../../widgets/ui_elements/side_drawer.dart';
import '../../widgets/strategy_widgets/task_list.dart';
import '../../scoped_model/main_model.dart';

/// [StrategicPage] class is the main strategic page which consists of 3 tab bars.
///
/// The three tabs are upcoming, overdue and completed showing 3 different types of tasks.
/// The class provides all the widget under the same widget tree with functions necessary to interact
/// with the Task Database. The functions are kept as [_addTask], [_removeTask], [_completeTask],
/// [_updateTask], [_getUpcomingTaskList], [_getOverdueTaskList], [_getCompletedTaskList] variables.
class StrategicPage extends StatelessWidget {
  Function _addTask,
      _removeTask,
      _completeTask,
      _updateTask,
      _getUpcomingTaskList,
      _getOverdueTaskList,
      _getCompletedTaskList;

  StrategicPage();

  Widget _buildTab(bool mode, int tabNumber) {
    if (mode)
      return Tab(
        icon: Icon(
          tabNumber == 0
              ? Icons.event_note
              : tabNumber == 1 ? Icons.event_busy : Icons.event_available,
        ),
        text: tabNumber == 0
            ? 'Upcoming'
            : tabNumber == 1 ? 'Overdue' : 'Completed',
      );

    return TaskList(
      tabNumber,
      tabNumber == 0
          ? _getUpcomingTaskList
          : tabNumber == 1 ? _getOverdueTaskList : _getCompletedTaskList,
      _addTask,
      _removeTask,
      _completeTask,
      _updateTask,
    );
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

        return DefaultTabController(
          length: 3,
          child: Scaffold(
            drawer: SideDrawer(4),
            appBar: AppBar(
              title: Text('Strategic'),
              bottom: TabBar(
                tabs: <Widget>[
                  _buildTab(true, 0),
                  _buildTab(true, 1),
                  _buildTab(true, 2),
                ],
              ),
            ),
            body: TabBarView(
              children: <Widget>[
                _buildTab(false, 0),
                _buildTab(false, 1),
                _buildTab(false, 2),
              ],
            ),
          ),
        );
      },
    );
  }
}
