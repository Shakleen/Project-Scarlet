import 'package:flutter/material.dart';

import '../widgets/ui_elements/side_drawer.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('About'),
      ),

      // Side drawer
      drawer: SideDrawer(7),

      body: Center(
        child: Text('This is the about page!'),
      ),
    );
  }
}
