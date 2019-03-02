import 'package:flutter/material.dart';

import '../../scoped_model/main_model.dart';

class TaskDatePicker extends StatefulWidget {
  DateTime dateTime;
  final Map<String, dynamic> formData;
  final String formDataKey;

  TaskDatePicker(this.formData, this.formDataKey, [this.dateTime]) {
    this.dateTime = this.dateTime == null ? DateTime.now() : this.dateTime;
  }

  @override
  State<StatefulWidget> createState() {
    return _TaskDatePicker();
  }
}

class _TaskDatePicker extends State<TaskDatePicker> {
  Color buttonColor;

  @override
  void initState() {
    buttonColor = Colors.blue;
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle =
        TextStyle(color: Colors.blueAccent, fontFamily: 'Roboto', fontSize: 16);
    return Padding(
      child: Column(
        children: <Widget>[
          Text(
            'Date/Time',
            style: labelStyle,
          ),
          SizedBox(height: 5.0),
          RaisedButton(
            color: buttonColor,
            child: Text(
              MainModel.dateFormatter.format(widget.dateTime),
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              return _selectDateTime(
                context,
                widget.dateTime,
                TimeOfDay(
                  hour: widget.dateTime.hour,
                  minute: widget.dateTime.minute,
                ),
              );
            },
          ),
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
    );
  }

  void _selectDateTime(
      BuildContext context, DateTime initDate, TimeOfDay initTime) async {
    final DateTime pickedDate = await showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay pickedTime = await showTimePicker(
        context: context,
        initialTime: initTime,
      );

      if (pickedTime != null) {
        widget.dateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          if (widget.dateTime.compareTo(DateTime.now()) > 0) {
            widget.formData[widget.formDataKey] = widget.dateTime;
            buttonColor = Colors.blue;
          } else {
            buttonColor = Colors.redAccent;
          }
        });
      }
    }
  }
}
