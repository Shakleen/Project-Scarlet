import 'package:flutter/material.dart';

class InfoBuilder extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String text;
  final bool type;

  InfoBuilder({
    Key key,
    @required this.text,
    @required this.icon,
    @required this.type,
    @required this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> list = [];
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double iconSize = Theme
        .of(context)
        .textTheme
        .subtitle
        .fontSize;
    final TextStyle textStyle = type == null
        ? Theme
        .of(context)
        .textTheme
        .display1
        : Theme
        .of(context)
        .textTheme
        .subtitle;
    double vert = 5.0,
        horz = 0.0,
        width = deviceWidth * 0.7;

    if (type != null) if (!type) {
      horz = 15.0;
      width = deviceWidth * 0.85;
    }

    if (icon != null && iconColor != null) {
      list.add(Icon(icon, color: iconColor, size: iconSize));
      list.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 2.0)));
    }

    list.add(Container(
      width: width,
      child: Text(text,
          style: textStyle, textAlign: TextAlign.justify, softWrap: true),
    ));

    return Container(
      child: Row(children: list),
      margin: EdgeInsets.symmetric(vertical: vert, horizontal: horz),
    );
  }
}
