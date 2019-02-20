import 'package:flutter/material.dart';

import '../widgets/ui_elements/side_drawer.dart';

class StrengthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Strength'),
      ),

      // Side drawer
      drawer: SideDrawer(1),

      body: Center(
        child: Text('This is the strength page!'),
      ),
    );
  }
}
