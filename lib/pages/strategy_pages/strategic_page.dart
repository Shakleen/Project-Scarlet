import 'package:flutter/material.dart';

import '../../widgets/ui_elements/side_drawer.dart';
import '../../widgets/strategy_widgets/task_list_view.dart';

/// [StrategicPage] class is the main strategic page which consists of 3 tab bars.
///
/// The three tabs are upcoming, overdue and completed showing 3 different types of tasks.
/// The class provides all the widget under the same widget tree with functions necessary to interact
/// with the Task Database. The functions are kept as [_addTask], [_removeTask], [_completeTask],
/// [_updateTask], [_getUpcomingTaskList], [_getOverdueTaskList], [_getCompletedTaskList] variables.
class StrategicPage extends StatelessWidget {
  final Function _addTask,
      _removeTask,
      _completeTask,
      _updateTask,
      _getUpcomingTaskList,
      _getOverdueTaskList,
      _getCompletedTaskList;

  StrategicPage(
    this._addTask,
    this._removeTask,
    this._completeTask,
    this._updateTask,
    this._getCompletedTaskList,
    this._getOverdueTaskList,
    this._getUpcomingTaskList,
  );

  Widget _buildTab(bool mode, int tabNumber) {
    if (mode) {
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
    }

    return TaskListView(
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
  }
}
