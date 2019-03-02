import 'package:flutter/material.dart';

/// Class for list tiles used in the SideDrawer class.
///
/// This is a widget that is used in SideDrawer widget.
/// [titleText] - title of the ListTile.
/// [leadingIcon] - icon of the ListTile.
/// [navigatorRoute] - route to navigate to once pressed.
/// [active] - true if page is currently in view, false otherwise.
class SideDrawerListTile extends StatelessWidget {
  final String titleText, route;
  final IconData leadingIcon;
  final bool active;
  final Color itemColor;

  SideDrawerListTile(
    this.titleText,
    this.route,
    this.leadingIcon,
    this.active,
    this.itemColor,
  );

  ListTile _buildListTile(BuildContext context) {
    return ListTile(
      leading: Icon(
        leadingIcon,
        color: active ? Colors.white : itemColor,
      ),
      title: Text(
        titleText,
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 14,
          color: active ? Colors.white : itemColor,
        ),
      ),
      selected: active,
      onTap: () {
        // Change only if inactive.
        if (active == false) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: active ? Colors.blue : Colors.white,
      ),
      child: _buildListTile(context),
    );
  }
}
