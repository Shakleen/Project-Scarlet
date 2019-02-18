import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';

class StrategicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Strategic'),
      ),

      // Side drawer
      drawer: SideDrawer(4),

      body: Center(
        child: Text('This is the Strategic page!'),
      ),
    );
  }
}
