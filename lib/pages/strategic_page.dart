import 'package:flutter/material.dart';

import '../widgets/side_drawer.dart';
import '../widgets/task_card.dart';

class StrategicPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Title of the app bar
      appBar: AppBar(
        title: Text('Strategic'),
      ),

      // Side drawer
      drawer: SideDrawer(4),

      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          TaskCard('Do push ups', DateTime(2019, 02, 18)),
          TaskCard('Go shopping', DateTime(2019, 02, 18)),
          TaskCard('Clean the car', DateTime(2019, 02, 18)),
          TaskCard('Study ML', DateTime(2019, 02, 18)),
          TaskCard('Make dinner', DateTime(2019, 02, 18)),
          TaskCard('Check emails', DateTime(2019, 02, 18)),
          TaskCard('Call parents', DateTime(2019, 02, 18)),
        ],
      ),

      // Floating action button for adding new tasks and goals
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          // TODO: Create a function to add goals and tasks.
        },
      ),
    );
  }
}
