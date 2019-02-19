import 'package:flutter/material.dart';

import './ui_elements/default_title.dart';
import './ui_elements/default_date.dart';

class TaskCard extends StatelessWidget {
  final String _title;
  final DateTime _dateTime;
  final Function removeTask;
  final int index;

  TaskCard(this._title, this._dateTime, this.removeTask, this.index);

  BoxDecoration _buildDecorations() {
    return BoxDecoration(
      // color: Colors.blueAccent,
      gradient: new LinearGradient(
        colors: [Colors.red[50], Colors.cyan[50]],
        begin: Alignment.centerRight,
        end: new Alignment(-1.0, -1.0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(1.5, 1.5),
          blurRadius: 0.5,
          spreadRadius: 0.5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildDecorations(),
      child: Column(
        children: <Widget>[
          // Contains a task
          ListTile(
            leading: IconButton(
              icon: Icon(
                Icons.done,
                size: 30,
                color: Colors.green,
              ),
              color: Colors.blueAccent,
              onPressed: () {},
            ),
            title: DefaultTitle(_title),
            trailing: DefaultDate(_dateTime),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 5.0),
    );
  }
}
