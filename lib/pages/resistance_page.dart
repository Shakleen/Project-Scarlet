import 'package:flutter/material.dart';
import 'package:project_scarlet/widgets/ui_elements/side_drawer.dart';

class ResistancePage extends StatefulWidget {
  ResistancePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResistancePageState();
}

class _ResistancePageState extends State<ResistancePage> {
  final String _page = 'Resistance Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(_page),
      appBar: AppBar(
        key: ValueKey('$_page AppBar'),
        title: Text('$_page', style: Theme.of(context).textTheme.title),
      ),
      drawer: SideDrawer(key: ValueKey('$_page Appbar'), activeNumber: 3),
      body: Center(child: Text('This is the $_page!')),
    );
  }
}
