import 'package:flutter/material.dart';

/// Class for list tiles used in the SideDrawer class.
/// 
/// This is a widget that is used in SideDrawer widget.
/// [titleText] - title of the ListTile.
/// [leadingIcon] - icon of the ListTile.
/// [navigatorRoute] - route to navigate to once pressed.
/// [active] - true if page is currently in view, false otherwise.
class SideDrawerListTile extends StatelessWidget {
  final String titleText;
  final IconData leadingIcon;
  final String navigatorRoute;
  final bool active;

  SideDrawerListTile(this.titleText, this.leadingIcon, this.navigatorRoute, this.active);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(titleText),
      selected: active,
      onTap: () {
        // Change only if inactive.
        if (active == false){
          Navigator.pushReplacementNamed(context, navigatorRoute);
        }
      },
    );
  }
}
