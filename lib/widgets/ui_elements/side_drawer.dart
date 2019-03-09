import 'package:flutter/material.dart';
import 'package:project_scarlet/presentation/standard_values.dart';
import 'package:project_scarlet/widgets/ui_elements/drawer_option_tile.dart';

/// Side drawer class used for navigation.
///
/// There are 8 option tiles which stand for the 8 different pages to navigate to.
/// The page currently in view is highlighted using the apps primary theme's deep color while
/// the rest are colored normally. The page which is currently in view is identified
/// by [activeNumber].
class SideDrawer extends StatelessWidget {
  final int activeNumber;

  SideDrawer({Key key, this.activeNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String _key = 'Side Drawer';
    final ThemeData theme = Theme.of(context);

    return Drawer(
      key: ValueKey('$_key Drawer'),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          if (index > 0) {
            final int i = index - 1;
            final bool active = (index - 1 == activeNumber);
            Color textColor = theme.secondaryHeaderColor;
            Color backGroundColor = theme.backgroundColor;

            if (active) {
              textColor = theme.primaryColorDark;
              backGroundColor = theme.primaryColorLight;
            }

            return DrawerOptionTile(
              key: ValueKey('$_key ${pageDetails[i][0]}'),
              title: pageDetails[i][0],
              pageRoute: pageDetails[i][1],
              leadingIcon: pageDetails[i][2],
              activeStatus: active,
              containerColor: backGroundColor,
              itemColor: textColor,
            );
          }

          return AppBar(
            key: ValueKey('$_key AppBar'),
            title: const Text('Navigation'),
          );
        },
      ),
    );
  }
}
