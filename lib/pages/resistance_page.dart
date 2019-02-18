import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';

class ResistancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Resistance Page'),
      ),

      // Side drawer
      drawer: SideDrawer(),

      body: Center(
        child: Text('This is the Resistance page!'),
      ),
    );
  }
}
