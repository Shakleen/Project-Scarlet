import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/bloc_provider.dart';
import 'package:project_scarlet/bloc/task_bloc.dart';
import 'package:project_scarlet/widgets/strategy_widgets/Strategy_FAB.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_list.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_operation_undo.dart';
import 'package:project_scarlet/widgets/ui_elements/side_drawer.dart';

/// Class for constructing the strategy page.
///
/// This is a stateful widget. The state is maintained by [_StrategicPageState] class.
class StrategicPage extends StatefulWidget {
  StrategicPage({Key key}) : super(key: key);

  @override
  State<StrategicPage> createState() => new _StrategicPageState();
}

/// State of [StrategicPage] class.
///
/// This class implements bloc pattern and bloc provider. The [_taskBloc] is a bloc
/// which is used for the data necessary for displaying this and its children widget.
/// The class has 3 tabs which are created and stored as a list in [_tabs]. Each tab
/// has a subsequent tab bar view whose information are sorted in [_tabBarViews] list.
class _StrategicPageState extends State<StrategicPage> {
  final String _page = 'Strategy Page';
  final _taskBloc = new TaskBloc();
  final List<Widget> _tabs = [], _tabBarViews = [];
  final List<Widget> _appBarButtons = [];

  @override
  void initState() {
    final Map<String, List> _tabData = const {
      'Upcoming': [Icons.event_note, 0],
      'Overdue': [Icons.event_busy, 1],
      'Completed': [Icons.event_available, 2],
    };

    for (String key in _tabData.keys) {
      _tabs.add(new Tab(
          key: ValueKey('$_page $key Tab'),
          text: key,
          icon: Icon(_tabData[key][0])));
      _tabBarViews.add(new TaskList(
          key: ValueKey('$_page $key TabView'), tabType: _tabData[key][1]));
    }

    _appBarButtons.add(IconButton(
      icon: Icon(Icons.search),
      onPressed: () {},
    ));
    _appBarButtons.add(TaskOperationUndo());

    super.initState();
  }

  @override
  void dispose() {
    _taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      key: ValueKey('$_page DefaultTabController'),

      // There will be 3 tabs which are upcoming, overdue and completed tabs.
      length: _tabs.length,

      // We use a bloc provider to provide taskBloc to the tabs for accessing the methods.
      child: BlocProvider(
        key: ValueKey('$_page BlocProvider'),

        // Each tab has a separate stream in the taskBloc.
        bloc: _taskBloc,

        // Page implementation
        child: Scaffold(
          key: ValueKey('$_page Scaffold'),
          drawer: SideDrawer(key: ValueKey('$_page Appbar'), activeNumber: 4),
          appBar: AppBar(
            key: ValueKey('$_page AppBar'),
            title: GestureDetector(
              child:
                  Text('Strategic', style: Theme.of(context).textTheme.title),
              onLongPress: () {},
            ),
            bottom: TabBar(tabs: _tabs),
            actions: _appBarButtons,
          ),

          // Main page body is the tab bar view
          body: TabBarView(children: _tabBarViews),

          // FAB for adding new tasks.
          floatingActionButton: StrategyFAB(key: ValueKey('$_page FAB')),
        ),
      ),
    );
  }
}



