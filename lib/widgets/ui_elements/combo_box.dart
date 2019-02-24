import 'package:flutter/material.dart';

import '../../scoped_model/task_model.dart';

class ComboBox extends StatefulWidget {
  int choice;

  ComboBox([this.choice = 0]);

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

    for (int i = 0; i < TaskModel.priorityLevels.length; ++i) {
      final String optionText = TaskModel.priorityLevels[i][0];
      final IconData optionIcon = TaskModel.priorityLevels[i][1];
      final Color optionColor = TaskModel.priorityLevels[i][2];

      items.add(DropdownMenuItem(
        value: i,
        child: Container(
          child: Row(
            children: <Widget>[
              Icon(
                optionIcon,
                color: optionColor,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              Text(
                optionText,
                style: TextStyle(color: optionColor),
              ),
              Divider(
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ));
    }

    return items;
  }

  void changedDropDownItem(int selectedCity) {
    setState(() {
      _currentChoice = selectedCity;
      widget.choice = _currentChoice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _currentChoice,
      items: _dropDownMenuItems,
      onChanged: changedDropDownItem,
    );
  }
}
