import 'package:flutter/material.dart';

import '../widgets/ui_elements/side_drawer.dart';

class AboutPage extends StatefulWidget {
  AboutPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final String _page = 'About Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey(_page),
      appBar: AppBar(
        key: ValueKey('$_page AppBar'),
        title: Text('$_page', style: Theme.of(context).textTheme.title),
      ),
      drawer: SideDrawer(key: ValueKey('$_page Appbar'), activeNumber: 7),
      body: Center(child: Text('This is the $_page!')),
    );
  }
}
