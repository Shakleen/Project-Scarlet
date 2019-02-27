import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import './scoped_model/task_model.dart';

import 'pages/home_page.dart';
import 'pages/strength_page.dart';
import 'pages/wisdom_page.dart';
import 'pages/resistance_page.dart';
import 'pages/strategy_pages/strategic_page.dart';
import 'pages/about_page.dart';
import 'pages/settings_page.dart';
import 'pages/play_game_page.dart';
import 'controller/task_database.dart';

main() {
  TaskDatabase.taskDatabase.initializeDatabase().whenComplete(() {
    TaskDatabase.taskDatabase.createViews();
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<TaskModel>(
      model: TaskModel(),
      child: ScopedModelDescendant<TaskModel>(
        builder: (BuildContext context, Widget child, TaskModel model) {
          return MaterialApp(
            // This sets the theme of the application
            theme: ThemeData(
              primaryColor: Colors.blue,
              accentColor: Colors.blueAccent,
              brightness: Brightness.light,
            ),

            // The application home page. The app will land here everytime it starts.
            home: HomePage(),

            // Creating a page registry
            routes: {
              '/strength': (BuildContext context) => StrengthPage(),
              '/wisdom': (BuildContext context) => WisdomPage(),
              '/resistance': (BuildContext context) => ResistancePage(),
              '/strategic': (BuildContext context) => StrategicPage(
                    model.addTask,
                    model.removeTask,
                    model.completeTask,
                    model.updateTask,
                    model.getCompletedTaskList,
                    model.getOverdueTaskList,
                    model.getUpcomingTaskList,
                  ),
              '/playgame': (BuildContext context) => PlayGamePage(),
              '/settings': (BuildContext context) => SettingsPage(),
              '/about': (BuildContext context) => AboutPage(),
            },
          );
        },
      ),
    );
  }
}
