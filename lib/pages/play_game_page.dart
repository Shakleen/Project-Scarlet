import 'package:flutter/material.dart';

import '../widgets/ui_elements/side_drawer.dart';

class PlayGamePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Play Game'),
      ),

      // Side drawer
      drawer: SideDrawer(5),

      body: Center(
        child: Text('This is the play game page!'),
      ),
    );
  }
}
