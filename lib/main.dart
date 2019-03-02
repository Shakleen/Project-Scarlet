import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'scoped_model/main_model.dart';

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
  State<StatefulWidget> createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: MainModel(),
      child: MaterialApp(
        // This sets the theme of the application
        theme: ThemeData(
          primaryColor: Colors.blue,
          accentColor: Colors.blueAccent,
          fontFamily: 'Roboto',
          brightness: Brightness.light,
        ),

        // The application home page. The app will land here everytime it starts.
        home: HomePage(),

        // Creating a page registry
        routes: {
          MainModel.navigationRoutes['strength'][0]: (BuildContext context) => StrengthPage(),
          MainModel.navigationRoutes['wisdom'][0]: (BuildContext context) => WisdomPage(),
          MainModel.navigationRoutes['resistance'][0]: (BuildContext context) => ResistancePage(),
          MainModel.navigationRoutes['strategic'][0]: (BuildContext context) => StrategicPage(),
          MainModel.navigationRoutes['play game'][0]: (BuildContext context) => PlayGamePage(),
          MainModel.navigationRoutes['settings'][0]: (BuildContext context) => SettingsPage(),
          MainModel.navigationRoutes['about'][0]: (BuildContext context) => AboutPage(),
        },
      ),
    );
  }
}
