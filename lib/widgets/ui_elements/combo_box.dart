import 'package:flutter/material.dart';

class ComboBox extends StatefulWidget {
  final Map<int, String> optionsMap;
  int choice;

  ComboBox(this.optionsMap, [this.choice = 0]);

  @override
  State<StatefulWidget> createState() {
    return _ComboBoxState();
  }
}

class _ComboBoxState extends State<ComboBox> {
  final List<String> _options = [];
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

    for (int i = 0; i < widget.optionsMap.length; ++i) {
      String optionText = widget.optionsMap[i];

      items.add(DropdownMenuItem(value: i, child: Text(optionText)));
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
