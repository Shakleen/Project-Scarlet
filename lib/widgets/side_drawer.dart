import 'package:flutter/material.dart';

import '../presentation/custom_icons.dart';
import './side_drawer_list_tile.dart';

/// Class for generating a side drawer that has the same overall structure for seven different pages.
///
/// The widget is used in all the pages and provides means of navigation to the user.
/// [_activeNumber] - page number currently active. Starts from 0 to total number of pages - 1.
class SideDrawer extends StatelessWidget {
  final int _activeNumber;

  SideDrawer(this._activeNumber);

  List<Widget> _buildListViewChildren() {
    final List<bool> _activeElement = [
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];

    _activeElement[_activeNumber] = true;

    return <Widget>[
      AppBar(
        automaticallyImplyLeading: false,
        title: Text('Navigation'),
      ),
      SideDrawerListTile(
        'Home',
        Icons.home,
        '/',
        _activeElement[0],
        Colors.blue,
      ),
      SideDrawerListTile(
        'Strength',
        CustomIcons.fist_raised_solid,
        '/strength',
        _activeElement[1],
        Colors.red,
      ),
      SideDrawerListTile(
        'Wisdom',
        CustomIcons.book_solid,
        '/wisdom',
        _activeElement[2],
        Colors.green,
      ),
      SideDrawerListTile(
        'Resistance',
        CustomIcons.shield_alt_solid,
        '/resistance',
        _activeElement[3],
        Colors.purple,
      ),
      SideDrawerListTile(
        'Strategic',
        CustomIcons.chess_knight_solid,
        '/strategic',
        _activeElement[4],
        Colors.deepOrangeAccent,
      ),
      SideDrawerListTile(
        'Play Game',
        Icons.play_arrow,
        '/playgame',
        _activeElement[5],
        Colors.indigoAccent,
      ),
      SideDrawerListTile(
        'Settings',
        Icons.settings,
        '/settings',
        _activeElement[6],
        Colors.black,
      ),
      SideDrawerListTile(
        'About',
        Icons.info,
        '/about',
        _activeElement[7],
        Colors.blueAccent,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        children: _buildListViewChildren(),
      ),
    );
  }
}
