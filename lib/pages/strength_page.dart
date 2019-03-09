import 'package:flutter/material.dart';
import 'package:project_scarlet/widgets/ui_elements/side_drawer.dart';

class StrengthPage extends StatefulWidget {
  StrengthPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _StrengthPageState();
}

class _StrengthPageState extends State<StrengthPage> {
  final String _page = 'Strength Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey('$_page'),
      appBar: AppBar(
        key: ValueKey('$_page AppBar'),
        title: Text('$_page', style: Theme.of(context).textTheme.title),
      ),
      drawer: SideDrawer(key: ValueKey('$_page Appbar'), activeNumber: 1),
      body: Center(child: Text('This is the $_page!')),
    );
  }
}
