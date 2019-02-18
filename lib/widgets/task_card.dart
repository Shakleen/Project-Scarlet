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
      border: Border.all(
        color: Colors.black,
        width: .5,
        style: BorderStyle.solid,
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

  ButtonBar _buildButtonBar() {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.done),
          color: Colors.blueAccent,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.snooze),
          color: Colors.green,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.info),
          color: Colors.orange,
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            removeTask(index);
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildDecorations(),
      margin: EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          // Task title
          DefaultTitle(_title),

          // Task due date
          DefaultDate(_dateTime),

          // Buttons to interact with a task
          _buildButtonBar(), 
        ],
      ),
    );
  }
}
