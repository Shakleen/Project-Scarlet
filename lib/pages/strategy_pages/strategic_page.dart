import 'package:flutter/material.dart';

import '../../widgets/ui_elements/side_drawer.dart';
import '../../presentation/custom_icons.dart';
import '../../widgets/strategy_widgets/task_list_view.dart';
import '../../controller/task_database.dart';

// class StrategicPage extends StatefulWidget {
//   @override
//   _StrategicPage createState() {
//     TaskDatabase.taskDatabase.createDatabase();
//     return _StrategicPage();
//   }
// }

/// Stateless widget class for our Strategy page.
///
/// The class implments a task management system. Each task is shown
/// as a card. The cards are tiled columnwise. The user may interact
/// with each Task Card in 3 ways.
/// 'Long Press' - Edit task.
/// 'Swipe left' - remove task.
/// 'Press tick button' - Complete task.
/// Each task card shows the name and date of the task.
/// Further more there is a floating action button which enable the user
/// to add more tasks.
// class _StrategicPage extends State<StrategicPage> {
class StrategicPage extends StatelessWidget {
  Widget _buildTabBar() {
    return TabBar(
      tabs: <Widget>[
        Tab(
          icon: Icon(CustomIcons.calendar_alt_regular),
          text: 'Upcoming',
        ),
        Tab(
          icon: Icon(CustomIcons.calendar_times_regular),
          text: 'Overdue',
        ),
        Tab(
          icon: Icon(CustomIcons.calendar_check_regular),
          text: 'Completed',
        ),
      ],
    );
  }

  /// Method for building TabView. Creates 3 tabs. Upcoming, Overdue and Completed tabs.
  Widget _buildTabBarView() {
    return TabBarView(
      children: <Widget>[
        TaskListView(0),
        TaskListView(1),
        TaskListView(2),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TaskDatabase.taskDatabase.createDatabase();
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: SideDrawer(4),
        appBar: AppBar(
          title: Text('Strategic'),
          bottom: _buildTabBar(),
        ),
        body: _buildTabBarView(),
      ),
    );
  }
}
