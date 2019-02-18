import 'package:flutter/material.dart';

// import 'package:scoped_model/scoped_model.dart';

import 'pages/home_page.dart';

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

      home: HomePage(),
    );
  }
}
