import 'package:flutter/material.dart';

/// Class for creating the default style of showing titles.
/// 
/// Shows the titles with proper decoration and formatting.
class DefaultTitle extends StatelessWidget {
  final String title;

  DefaultTitle(this.title);

  /// Method for building the decoration of the title to be shown.
  TextStyle _buildTextStyle() {
    return TextStyle(
      fontSize: 26,
      fontFamily: 'Roboto',
      shadows: [
        Shadow(
          color: Colors.grey[300],
          offset: Offset(1.0, 1.0),
          blurRadius: 1.5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Text(
        title,
        style: _buildTextStyle(),
      ),
    );
  }
}
