import 'package:flutter/material.dart';
import 'package:project_scarlet/widgets/strategy_widgets/info_builder.dart';

class TaskCardTitle extends StatelessWidget {
  final List<List> info;

  TaskCardTitle({Key key, this.info}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Column(children: List<Widget>.generate(info.length, _itemBuilder));

  Widget _itemBuilder(int index) {
    return InfoBuilder(
      key: Key('Task card title ${info[index][0]}'),
      text: info[index][0],
      textStyle: info[index][1],
      icon: info[index][2],
      iconColor: info[index][3],
      width: info[index][4],
    );
  }
}