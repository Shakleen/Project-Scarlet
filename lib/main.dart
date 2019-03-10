import 'package:flutter/material.dart';
import 'package:project_scarlet/controller/task_database.dart';
import 'package:project_scarlet/entities/task_entity.dart';
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
    TaskDatabase.taskDatabase.createViews().whenComplete(() {
      for (int i = 0; i < 10000; ++i) {
        final int mod = i % 4;
        TaskDatabase.taskDatabase.insertTask(TaskEntity(
          name: "Task no $i",
          description: "This is a very very very long description to overload the memory so bear with me a little bit cause I am desperate $i",
          location: "This is a very very very long location to overload the memory so bear with me a little bit cause I am desperate $i",
          dueDate: mod == 1 ? DateTime.now().add(Duration(hours: i)) : DateTime
              .now().subtract(Duration(minutes: i)),
          setDate: DateTime.now().add(Duration(minutes: i)),
          priority: mod,
          difficulty: mod,
          completeDate: mod == 0
              ? DateTime.now().add(Duration(minutes: 2))
              : null,
        ));
      }
      print('10K values insertion successful!');
    });
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
