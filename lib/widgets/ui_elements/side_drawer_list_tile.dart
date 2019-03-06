import 'package:flutter/material.dart';

/// Class for list tiles used in the SideDrawer class.
class SideDrawerListTile extends StatelessWidget {
  final String titleText, route;
  final IconData leadingIcon;
  final bool active;
  Color activeTextColor, backgroundColor, normalTextColor;

  SideDrawerListTile(this.titleText, this.route, this.leadingIcon, this.active);

  ListTile _buildListTile(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon, color: active ? activeTextColor : normalTextColor),
      title: Text(
        titleText,
        style: Theme.of(context)
            .textTheme
            .subhead
            .copyWith(color: active ? activeTextColor : normalTextColor),
      ),
      selected: active,
      onTap: () {
        if (active == false) Navigator.pushReplacementNamed(context, route);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    activeTextColor = Theme.of(context).primaryColorDark;
    normalTextColor = Theme.of(context).secondaryHeaderColor;
    backgroundColor = Theme.of(context).backgroundColor;

    return Container(
      decoration: BoxDecoration(
        color: active ? Theme.of(context).primaryColorLight : backgroundColor,
        borderRadius: active
            ? BorderRadius.only(
                topRight: Radius.circular(25.0),
                bottomRight: Radius.circular(25.0),
              )
            : null,
      ),
      child: _buildListTile(context),
    );
  }
}
