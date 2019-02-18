import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Settings'),
      ),

      // Side drawer
      drawer: SideDrawer(6),

      body: Center(
        child: Text('This is the settings page!'),
      ),
    );
  }
}
