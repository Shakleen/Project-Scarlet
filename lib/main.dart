import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import './scoped_model/task_model.dart';

import 'pages/home_page.dart';
import 'pages/strength_page.dart';
import 'pages/wisdom_page.dart';
import 'pages/resistance_page.dart';
import 'pages/strategic_page.dart';
import 'pages/about_page.dart';
import 'pages/settings_page.dart';
import 'pages/play_game_page.dart';

main() {
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
      child: MaterialApp(
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
          '/strategic': (BuildContext context) => StrategicPage(),
          '/playgame': (BuildContext context) => PlayGamePage(),
          '/settings': (BuildContext context) => SettingsPage(),
          '/about': (BuildContext context) => AboutPage(),
        },
      ),
    );
  }
}
