import 'package:flutter/material.dart';

import '../widgets/ui_elements/side_drawer.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.title,
        ),
      ),

      // Side drawer
      drawer: SideDrawer(6),

      body: Center(
        child: Text('This is the settings page!'),
      ),
    );
  }
}
