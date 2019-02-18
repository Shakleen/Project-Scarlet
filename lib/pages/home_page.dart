import 'package:flutter/material.dart';

import '../presentation/custom_icons.dart';

class HomePage extends StatelessWidget {
  Drawer sideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Navigation'),
          ),

          ListTile(
            leading: Icon(CustomIcons.fist_raised_solid),
            title: Text('Strength'),
            onTap: () {}
          ),

          ListTile(
            leading: Icon(CustomIcons.book_solid),
            title: Text('Wisdom'),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(CustomIcons.shield_alt_solid),
            title: Text('Resistance'),
            onTap: () {}
          ),

          ListTile(
            leading: Icon(CustomIcons.chess_knight_solid),
            title: Text('Strategic'),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {},
          ),

          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            onTap: () {}
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Home Page'),
      ),

      // Side drawer
      drawer: sideDrawer(context),

      body: Center(
        child: Text('This is the home page!'),
      ),
    );
  }
}
