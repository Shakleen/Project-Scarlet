import 'package:flutter/material.dart';

/// Drawer option tile class for the side drawer.
///
/// This class creates a tile with a [title] and an [leadingIcon]. It implements an on tap
/// function that is used to [pageRoute] to any page in the app. The navigation only
/// works if the tile isn't currently [activeStatus]. The tile title and icon is colored
/// in [itemColor] and the container is colored in [containerColor].
class DrawerOptionTile extends StatelessWidget {
  final Color containerColor, itemColor;
  final IconData leadingIcon;
  final String title, pageRoute;
  final bool activeStatus;

  DrawerOptionTile({
    @required Key key,
    @required this.title,
    @required this.leadingIcon,
    @required this.itemColor,
    @required this.containerColor,
    @required this.activeStatus,
    @required this.pageRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: containerColor),
      child: ListTile(
        leading: Icon(leadingIcon, color: itemColor),
        title: Text(title, style: Theme.of(context).textTheme.subhead),
        selected: activeStatus,
        onTap: () {
          if (!activeStatus) Navigator.pushReplacementNamed(context, pageRoute);
        },
      ),
    );
  }
}
