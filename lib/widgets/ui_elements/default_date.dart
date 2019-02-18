import 'package:flutter/material.dart';

class DefaultDate extends StatelessWidget {
  final String date;

  DefaultDate(this.date);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      padding: EdgeInsets.all(5.0),
      child: Text(
        date,
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
