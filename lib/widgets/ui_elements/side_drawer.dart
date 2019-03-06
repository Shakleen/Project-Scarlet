import 'package:flutter/material.dart';

import './side_drawer_list_tile.dart';
import 'package:project_scarlet/presentation/standard_values.dart';

/// Class for generating a side drawer that has the same overall structure for seven different pages.
///
/// The widget is used in all the pages and provides means of navigation to the user.
/// [_activeNumber] - page number currently active. Starts from 0 to total number of pages - 1.
class SideDrawer extends StatelessWidget {
  final int _activeNumber;

  SideDrawer(this._activeNumber);

  List<Widget> _buildListViewChildren() {
    List<Widget> children = [AppBar(
      automaticallyImplyLeading: false,
      title: Text('Navigation'),
    )];

    for (int i = 0; i < StandardValues.navigationRoutes.keys.length; ++i) {
      String key = _getKey(i);
      children.add(SideDrawerListTile(
        key,
        StandardValues.navigationRoutes[key.toLowerCase()][0],
        StandardValues.navigationRoutes[key.toLowerCase()][1],
        i == _activeNumber ? true : false,
      ));
    }

    return children;
  }

  String _getKey(int i) {
    if (i == 0) return 'Home';
    else if (i == 1) return 'Strength';
    else if (i == 2) return 'Wisdom';
    else if (i == 3) return 'Resistance';
    else if (i == 4) return 'Strategic';
    else if (i == 5) return 'Play Game';
    else if (i == 6) return 'Settings';
    else if (i == 7) return 'About';
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
