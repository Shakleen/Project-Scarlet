import 'package:flutter/material.dart';

/// A widget for a common way of showing the date.
///
/// Class object takes [_dateTime] as input and then
/// builds a widget to display it with proper background
/// coloring and formatting.
class DefaultDate extends StatelessWidget {
  final DateTime _dateTime;

  DefaultDate(this._dateTime);

  /// Method for decorating the container the date will
  /// be housed in.
  BoxDecoration _buildBoxDecoration() {
    // If the task due is before our current date, show red color. Otherwise green.
    final Color _boxColor = //Colors.green;
        (_dateTime.compareTo(DateTime.now()) < 0) ? Colors.red : Colors.green;

    return BoxDecoration(
      color: _boxColor,
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      boxShadow: [
        BoxShadow(
          blurRadius: 1.0,
          color: Colors.grey,
          offset: Offset(1.2, 1.2),
          spreadRadius: 1.2,
        ),
      ],
    );
  }

  /// Method for preparing the text to show the dates with
  /// proper formatting.
  Text _buildDateText() {
    // Convert our date into string of format YYYY/MM/DD
    final String _displayDate = _dateTime.year.toString() +
        "/" +
        _dateTime.month.toString() +
        "/" +
        _dateTime.day.toString();

    return Text(
      _displayDate,
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.normal,
        fontFamily: 'Roboto',
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(),
      padding: EdgeInsets.all(5.0),
      child: _buildDateText(),
    );
  }
}
