import 'package:flutter/material.dart';
import 'package:project_scarlet/widgets/ui_elements/side_drawer.dart';

class PlayGamePage extends StatefulWidget {
  PlayGamePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PlayGamePageState();
}

class _PlayGamePageState extends State<PlayGamePage> {
  final String _page = 'Play game Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(_page),
      appBar: AppBar(
        key: ValueKey('$_page AppBar'),
        title: Text('$_page', style: Theme.of(context).textTheme.title),
      ),
      drawer: SideDrawer(key: ValueKey('$_page Appbar'), activeNumber: 5),
      body: Center(child: Text('This is the $_page!')),
    );
  }
}
