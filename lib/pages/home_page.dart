import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Home'),
      ),

      // Side drawer
      drawer: SideDrawer(0),

      body: Center(
        child: Text('This is the home page!'),
      ),
    );
  }
}
