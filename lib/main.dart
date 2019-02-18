import 'package:flutter/material.dart';

// import 'package:scoped_model/scoped_model.dart';

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
        '/strategic': (BuildContext context) => StrategicPage(),
        '/playgame': (BuildContext context) => PlayGamePage(),
        '/settings': (BuildContext context) => SettingsPage(),
        '/about': (BuildContext context) => AboutPage(),
      },

      // Passing data according to which page was accessed
      // onGenerateRoute: (RouteSettings settings) {
      //   final List<String> pathElements = settings.name.split('/');

      //   if (pathElements[0] != '') {
      //     return null;
      //   }

      //   if (pathElements[1] == 'product') {
      //     final int index = int.parse(pathElements[2]);

      //     return MaterialPageRoute<bool>(
      //       builder: (BuildContext context) => ProductPage(index),
      //     );
      //   }

      //   return null;
      // },

      // onUnknownRoute: (RouteSettings settings) {
      //   return MaterialPageRoute(
      //     builder: (BuildContext context) => ProductsPage(),
      //   );
      // },
    );
  }
}
