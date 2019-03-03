import 'package:flutter/material.dart';

import '../widgets/ui_elements/side_drawer.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text(
          'Home',
          style: Theme.of(context).textTheme.title,
        ),
      ),

      // Side drawer
      drawer: SideDrawer(0),

      body: Center(
        child: Text('This is the home page!'),
      ),
    );
  }
}
