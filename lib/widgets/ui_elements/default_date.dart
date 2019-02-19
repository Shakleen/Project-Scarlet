import 'package:flutter/material.dart';

class DefaultDate extends StatelessWidget {
  final DateTime _dateTime;

  DefaultDate(this._dateTime);

  @override
  Widget build(BuildContext context) {
    // If the task due is before our current date, show red color. Otherwise green.
    final Color _boxColor = //Colors.green;
        (_dateTime.compareTo(DateTime.now()) < 0) ? Colors.red : Colors.green;
    
    // Convert our date into string of format YYYY/MM/DD
    final String _displayDate = _dateTime.year.toString() +
        "/" +
        _dateTime.month.toString() +
        "/" +
        _dateTime.day.toString();

    return Container(
      decoration: BoxDecoration(
        color: _boxColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.all(5.0),
      child: Text(
        _displayDate,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
      ),
    );
  }
}
