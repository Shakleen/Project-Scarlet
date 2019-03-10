import 'package:flutter/material.dart';

class InfoBuilder extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;
  final TextStyle textStyle;
  final double width;
  final List<Widget> list = [];

  InfoBuilder({
    Key key,
    @required this.text,
    @required this.textStyle,
    @required this.icon,
    @required this.iconColor,
    @required this.width,
  }) : super(key: key) {
    final Icon shownIcon = icon != null
        ? Icon(icon, size: textStyle.fontSize, color: iconColor)
        : null;
    if (shownIcon != null) {
      list.add(shownIcon);
      list.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)));
    }

    list.add(Container(
      width: width,
      child: Text(
        text,
        style: textStyle,
        textAlign: TextAlign.justify,
        softWrap: true,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: list),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
    );
  }
}
