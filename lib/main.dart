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

/// This is where the app begins execution.
///
/// The main function first calls [initializeDatabase] via [taskDatabase] object
/// to load existing or create new database. This is required for the strategy
/// portion of the application to work. When table creation is finished the views
/// for extracting data are created. When this preparation phase is done the main
/// application UI is loaded. In this case, [MyApp] class is the application UI.
main() {
  TaskDatabase.taskDatabase.initializeDatabase().whenComplete(() {
    TaskDatabase.taskDatabase.createViews().whenComplete(() {
//      for (int i = 0; i < 1000; ++i) {
//        final int mod = i % 4, mod2 = i % 11, mod3 = i % 7;
//        TaskDatabase.taskDatabase.insertTask(TaskEntity(
//          name: "Task $i" + (mod2 == 0 ? " done" : " not"),
//          description: "This is a very very very long description to overload the memory so bear with me a little bit cause I am desperate $i",
//          location: "This is a very very very long location to overload the memory so bear with me a little bit cause I am desperate $i",
//          dueDate: mod3 == 0 ? DateTime.now().add(Duration(hours: i)) : DateTime
//              .now().subtract(Duration(minutes: i)),
//          setDate: DateTime.now().add(Duration(minutes: i)),
//          priority: mod,
//          difficulty: mod,
//          completeDate: mod2 == 0
//              ? DateTime.now().add(Duration(minutes: 2))
//              : null,
//        ));
//      }
//      print('1K values insertion successful!');
    });
  });
  runApp(MyApp(key: GlobalKey()));
}

/// Main application UI class.
///
/// The state of [MyApp] class is [_MyAppState].
class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

/// Main application UI state.
///
/// The class sets the standard theme for the application and necessary page
/// routes for navigation. It also sets the home page as well.
class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // Material creates a default theme and routes for navigation.
    return MaterialApp(
      // For debugging purposes TODO DEBUG
      showPerformanceOverlay: true,

      // Setting application theme
      theme: ThemeData(
        // Primary colors
        primaryColor: Colors.blue,
        primaryColorLight: Colors.blue[75],
        primaryColorDark: Colors.blue[800],

        // Secondary color
        accentColor: Colors.blueAccent,

        // Brightness
        brightness: Brightness.light,
        primaryColorBrightness: Brightness.dark,
        accentColorBrightness: Brightness.dark,
        errorColor: Colors.red,

        highlightColor: Colors.white,
        backgroundColor: Colors.white,
        fontFamily: 'Roboto',

        // Text theme
        textTheme: TextTheme(
          title: TextStyle(color: Colors.white),
          headline: TextStyle(color: Colors.black),
          subtitle: TextStyle(color: Colors.black),
          subhead: TextStyle(color: Colors.blueAccent),
          body1: TextStyle(color: Colors.black),
          display1: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.white70, size: 26),
        secondaryHeaderColor: Colors.black54,
        buttonColor: Colors.blue,
        bottomAppBarColor: Colors.blue,
      ),

      // Home page
      home: HomePage(key: ValueKey('HomePage')),

      // Navigation routes.
      routes: {
        pageDetails[1][1]: (BuildContext context) =>
            StrengthPage(key: ValueKey('StrengthPage')),
        pageDetails[2][1]: (BuildContext context) =>
            WisdomPage(key: ValueKey('WisdomPage')),
        pageDetails[3][1]: (BuildContext context) =>
            ResistancePage(key: ValueKey('ResistancePage')),
        pageDetails[4][1]: (BuildContext context) =>
            StrategicPage(key: ValueKey('StrategicPage')),
        pageDetails[5][1]: (BuildContext context) =>
            PlayGamePage(key: ValueKey('PlayGamePage')),
        pageDetails[6][1]: (BuildContext context) =>
            SettingsPage(key: ValueKey('SettingsPage')),
        pageDetails[7][1]: (BuildContext context) =>
            AboutPage(key: ValueKey('AboutPage')),
      },
    );
  }
}
