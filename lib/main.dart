import 'package:flutter/material.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/pages/about_page.dart';
import 'package:project_scarlet/pages/home_page.dart';
import 'package:project_scarlet/pages/play_game_page.dart';
import 'package:project_scarlet/pages/resistance_page.dart';
import 'package:project_scarlet/pages/settings_page.dart';
import 'package:project_scarlet/pages/strategy_pages/strategic_page.dart';
import 'package:project_scarlet/pages/strength_page.dart';
import 'package:project_scarlet/pages/wisdom_page.dart';
import 'package:project_scarlet/presentation/standard_values.dart';

main() {
  TaskDatabase.taskDatabase.initializeDatabase().whenComplete(() {
    TaskDatabase.taskDatabase.createViews();
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // This sets the theme of the application
      theme: StandardValues.defaultTheme,

      builder: (BuildContext context, Widget child) {

      },

      // The application home page. The app will land here everytime it starts.
      home: HomePage(),

      // Creating a page registry
      routes: {
        StandardValues.navigationRoutes['strength'][0]: (BuildContext context) =>
            StrengthPage(),
        StandardValues.navigationRoutes['wisdom'][0]: (BuildContext context) =>
            WisdomPage(),
        StandardValues.navigationRoutes['resistance'][0]: (BuildContext context) =>
            ResistancePage(),
        StandardValues.navigationRoutes['strategic'][0]: (BuildContext context) =>
            StrategicPage(),
        StandardValues.navigationRoutes['play game'][0]: (BuildContext context) =>
            PlayGamePage(),
        StandardValues.navigationRoutes['settings'][0]: (BuildContext context) =>
            SettingsPage(),
        StandardValues.navigationRoutes['about'][0]: (BuildContext context) =>
            AboutPage(),
      },
    );
  }
}
