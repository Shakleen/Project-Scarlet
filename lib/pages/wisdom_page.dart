import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';

class WisdomPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Wisdom Page'),
      ),

      // Side drawer
      drawer: SideDrawer(),

      body: Center(
        child: Text('This is the wisdom page!'),
      ),
    );
  }
}
