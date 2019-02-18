import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';

class ResistancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Resistance'),
      ),

      // Side drawer
      drawer: SideDrawer(3),

      body: Center(
        child: Text('This is the Resistance page!'),
      ),
    );
  }
}
