import 'package:flutter/material.dart';
import 'package:project_scarlet/bloc/strategy/bloc_provider.dart';
import 'package:project_scarlet/bloc/strategy/task_bloc.dart';
import 'package:project_scarlet/pages/strategy_pages/task_form_page.dart';
import 'package:project_scarlet/widgets/strategy_widgets/task_list.dart';
import 'package:project_scarlet/widgets/ui_elements/side_drawer.dart';

/// [StrategicPage] class is the main strategic page which consists of 3 tab bars.
class StrategicPage extends StatefulWidget {
  @override
  _StrategicPageState createState() => _StrategicPageState();
}

class _StrategicPageState extends State<StrategicPage> {
  final taskBloc = TaskBloc();
  final Map<String, List> tabData = {
    'Upcoming': [Icons.event_note, 0],
    'Overdue': [Icons.event_busy, 1],
    'Completed': [Icons.event_available, 2],
  };
  final List<Widget> tabs = [], tabBarViews = [];

  _StrategicPageState() {
    for (String key in tabData.keys) {
      final int tabNumber = tabData[key][1];
      final IconData icon = tabData[key][0];

      tabs.add(new Tab(text: key, icon: Icon(icon)));
      tabBarViews.add(TaskList(tabNumber));
    }
  }

  @override
  void dispose() {
    taskBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: BlocProvider(
        bloc: taskBloc,
        child: Scaffold(
          drawer: SideDrawer(4),
          appBar: _buildAppbar(tabs),
          body: TabBarView(children: tabBarViews),
          floatingActionButton: _buildFAB(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: _buildBottomNavBar(),
        ),
      ),
    );
  }

  Widget _buildAppbar(List<Widget> tabs) {
    return AppBar(
      title: Text('Strategic', style: Theme.of(context).textTheme.title),
      bottom: TabBar(tabs: tabs),
    );
  }

  /// Method for building the floating action button. It generates a new
  /// form for creating a new task. The button passes in [addTask] to the
  /// form for adding the new task to the list of tasks.
  Widget _buildFAB() {
    return FloatingActionButton(
      child: Icon(Icons.add, color: Theme.of(context).backgroundColor),
      backgroundColor: Colors.red,
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    TaskForm(null, taskBloc.addTask, taskBloc.updateTask)));
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(icon: Icon(Icons.undo), tooltip: 'Undo', onPressed: () {}),
          IconButton(icon: Icon(Icons.redo), tooltip: 'Redo', onPressed: () {}),
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: Theme.of(context).primaryColor,
    );
  }
}
