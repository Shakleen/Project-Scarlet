import 'package:flutter/material.dart';

import '../presentation/custom_icons.dart';
import './side_drawer_list_tile.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Navigation'),
          ),

          SideDrawerListTile('Strength', CustomIcons.fist_raised_solid, '/strength'),
          SideDrawerListTile('Wisdom', CustomIcons.book_solid, '/wisdom'),
          SideDrawerListTile('Resistance', CustomIcons.shield_alt_solid, '/resistance'),
          SideDrawerListTile('Strategic', CustomIcons.chess_knight_solid, '/strategic'),
          SideDrawerListTile('Settings', Icons.settings, '/settings'),
          SideDrawerListTile('About', Icons.info, '/about'),
        ],
      ),
    );
  }
}