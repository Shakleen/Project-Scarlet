import 'package:flutter/material.dart';

class TaskDismissContainer extends StatelessWidget {
  final Color color;
  final IconData icon;
  final MainAxisAlignment mainAxisAlignment;

  TaskDismissContainer({Key key, this.color, this.icon, this.mainAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Row(
        children: <Widget>[Icon(icon, size: 35.0, color: Colors.white)],
        mainAxisAlignment: mainAxisAlignment,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0),
    );
  }
}