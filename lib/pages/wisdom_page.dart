import 'package:flutter/material.dart';

import '../widgets/ui_elements/side_drawer.dart';

class WisdomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Wisdom'),
      ),

      // Side drawer
      drawer: SideDrawer(2),

      body: Center(
        child: Text('This is the wisdom page!'),
      ),
    );
  }
}
