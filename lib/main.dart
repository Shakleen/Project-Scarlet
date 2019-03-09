import 'package:flutter/material.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/pages/about_page.dart';
import 'package:project_scarlet/pages/home_page.dart';
import 'package:project_scarlet/pages/play_game_page.dart';
import 'package:project_scarlet/pages/resistance_page.dart';
import 'package:project_scarlet/pages/settings_page.dart';
import 'package:project_scarlet/pages/strategic_page.dart';
import 'package:project_scarlet/pages/strength_page.dart';
import 'package:project_scarlet/pages/wisdom_page.dart';
import 'package:project_scarlet/presentation/standard_values.dart';

main() {
  TaskDatabase.taskDatabase.initializeDatabase().whenComplete(() {
    TaskDatabase.taskDatabase.createViews().whenComplete(() {});
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  final GlobalKey globalKey = GlobalKey();

  @override
  State<StatefulWidget> createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      showPerformanceOverlay: true,
      key: widget.globalKey,
      theme: defaultTheme,
      home: new HomePage(key: ValueKey('HomePage')),
      routes: {
        pageDetails[1][1]: (BuildContext context) =>
            new StrengthPage(key: ValueKey('StrengthPage')),
        pageDetails[2][1]: (BuildContext context) =>
            new WisdomPage(key: ValueKey('WisdomPage')),
        pageDetails[3][1]: (BuildContext context) =>
            new ResistancePage(key: ValueKey('ResistancePage')),
        pageDetails[4][1]: (BuildContext context) =>
            new StrategicPage(key: ValueKey('StrategicPage')),
        pageDetails[5][1]: (BuildContext context) =>
            new PlayGamePage(key: ValueKey('PlayGamePage')),
        pageDetails[6][1]: (BuildContext context) =>
            new SettingsPage(key: ValueKey('SettingsPage')),
        pageDetails[7][1]: (BuildContext context) =>
            new AboutPage(key: ValueKey('AboutPage')),
      },
    );
  }
}
