import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_database_bloc.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_bottom_nav_bar.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_fab.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_list.dart';
import 'package:project_scarlet/widgets/ui_elements/side_drawer.dart';

/// Class for constructing the strategy page.
///
/// This is a stateful widget. The state is maintained by [_StrategicPageState] class.
class StrategicPage extends StatefulWidget {
  StrategicPage({Key key}) : super(key: key);

  @override
  State<StrategicPage> createState() => _StrategicPageState();
}

/// State of [StrategicPage] class.
///
/// This class implements bloc pattern and bloc provider. The [_taskBloc] is a bloc
/// which is used for the data necessary for displaying this and its children widget.
/// The class has 3 tabs which are created and stored as a list in [_tabs]. Each tab
/// has a subsequent tab bar view whose information are sorted in [_tabBarViews] list.
class _StrategicPageState extends State<StrategicPage>
    with SingleTickerProviderStateMixin {
  final String _page = 'Strategy Page';
  final _taskBloc = TaskDatabaseBloc();
  TabController _tabController;
  int _current;

  @override
  void initState() {
    _current = 0;
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<TaskDatabaseBloc>(
      key: ValueKey('$_page Bloc Provider'),
      bloc: _taskBloc,

      // Main page implementation
      child: Scaffold(
        key: ValueKey('$_page Scaffold'),

        // Side drawer
        drawer: SideDrawer(
          key: ValueKey('$_page Side drawer'),
          activeNumber: 4,
        ),

        // App bar of page
        appBar: AppBar(
          key: ValueKey('$_page AppBar'),
          title: GestureDetector(
            key: ValueKey('$_page Title Gesture detector'),
            child: Text('Strategic', style: Theme
                .of(context)
                .textTheme
                .title),
            onLongPress: () {},
          ),
        ),

        // For navigating around completed and scheduled options.
        bottomNavigationBar: TaskBottomNavBar(
          key: ValueKey('$_page Bottom NavBar'),
          index: _current,
          changeFunction: _changeTabs,
        ),

        // Main page body is the tab bar view
        body: TabBarView(
          key: ValueKey('$_page Tab bar view'),
          controller: _tabController,
          children: <Widget>[
            TaskList(key: ValueKey('$_page Task List 0'), tabType: 0),
            TaskList(key: ValueKey('$_page Task List 1'), tabType: 1)
          ],
        ),

        // Floating action button
        floatingActionButton: TaskFAB(
          key: ValueKey('$_page Task FAB'),
          expandedColor: Theme
              .of(context)
              .errorColor,
          shrinkColor: Theme
              .of(context)
              .primaryColor,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }

  void _changeTabs(int index) {
    if (_current != index) {
      _current = index;
      _taskBloc.changeStream(_current);
      _tabController.animateTo(_current);
    }
  }
}
