import 'package:flutter/material.dart';

/// A class which creates a bottom app bar for the strategy page.
///
/// The created widget has 4 buttons for undo, redo, sort and search functionality.
class StrategyBottomAppBar extends StatelessWidget {
  StrategyBottomAppBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.undo),
            tooltip: 'Undo',
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.sort),
            tooltip: 'Sort',
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.redo),
            tooltip: 'Redo',
            onPressed: () {},
          ),
        ],
      ),
      shape: CircularNotchedRectangle(),
      color: Theme.of(context).primaryColor,
    );
  }
}
