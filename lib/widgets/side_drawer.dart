import 'package:flutter/material.dart';

import '../presentation/custom_icons.dart';
import './side_drawer_list_tile.dart';

/// Class for generating a side drawer that has the same overall structure for seven different pages.
/// 
/// The widget is used in all the pages and provides means of navigation to the user.
/// [activeNumber] - page number currently active. Starts from 0 to total number of pages - 1.
class SideDrawer extends StatelessWidget {
  final int activeNumber;

  SideDrawer(this.activeNumber);

  @override
  Widget build(BuildContext context) {
    final List<bool> _activeElement = [false, false, false, false, false, false, false, false];

    _activeElement[activeNumber] = true;

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Navigation'),
          ),

          SideDrawerListTile('Home', Icons.home, '/', _activeElement[0]),
          SideDrawerListTile('Strength', CustomIcons.fist_raised_solid, '/strength', _activeElement[1]),
          SideDrawerListTile('Wisdom', CustomIcons.book_solid, '/wisdom', _activeElement[2]),
          SideDrawerListTile('Resistance', CustomIcons.shield_alt_solid, '/resistance', _activeElement[3]),
          SideDrawerListTile('Strategic', CustomIcons.chess_knight_solid, '/strategic', _activeElement[4]),
          SideDrawerListTile('Play Game', Icons.play_arrow, '/playgame', _activeElement[5]),
          SideDrawerListTile('Settings', Icons.settings, '/settings', _activeElement[6]),
          SideDrawerListTile('About', Icons.info, '/about', _activeElement[7]),
        ],
      ),
    );
  }
}