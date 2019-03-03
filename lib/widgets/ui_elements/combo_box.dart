import 'package:flutter/material.dart';

class ComboBox extends StatefulWidget {
  int choice;
  final Map<int, List<dynamic>> levels;
  final Map<String, dynamic> formData;
  final String labelName;

  ComboBox(this.levels, this.formData, this.labelName, [this.choice = 0]);

  @override
  State<StatefulWidget> createState() {
    return _ComboBoxState();
  }
}

class _ComboBoxState extends State<ComboBox> {
  List<DropdownMenuItem<int>> _dropDownMenuItems;
  int _currentChoice;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentChoice = widget.choice;

    super.initState();
  }

  List<DropdownMenuItem<int>> getDropDownMenuItems() {
    List<DropdownMenuItem<int>> items = List();

    for (int i = 0; i < widget.levels.length; ++i) {
      final String optionText = widget.levels[i][0];
      final IconData optionIcon = widget.levels[i][1];
      final Color optionColor = widget.levels[i][2];

      items.add(DropdownMenuItem(
        value: i,
        child: Container(
          child: Row(
            children: <Widget>[
              Icon(optionIcon, color: optionColor),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5.0)),
              Text(optionText, style: TextStyle(color: optionColor)),
            ],
          ),
        ),
      ));
    }

    return items;
  }

  void changedDropDownItem(int selection) {
    setState(() {
      widget.formData[widget.labelName] =
          widget.choice = _currentChoice = selection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.labelName,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: Theme.of(context).accentColor),
          ),
          DropdownButton(
            value: _currentChoice,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
          ),
        ],
      ),
      padding: EdgeInsets.only(top: 10.0, right: 10.0),
    );
  }
}
