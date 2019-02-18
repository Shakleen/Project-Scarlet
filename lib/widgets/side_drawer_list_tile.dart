import 'package:flutter/material.dart';

class SideDrawerListTile extends StatelessWidget {
  final String titleText;
  final IconData leadingIcon;
  final String navigatorRoute;

  SideDrawerListTile(this.titleText, this.leadingIcon, this.navigatorRoute);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: Text(titleText),
      onTap: () {
        Navigator.pushReplacementNamed(context, navigatorRoute);
      },
    );
  }
}
