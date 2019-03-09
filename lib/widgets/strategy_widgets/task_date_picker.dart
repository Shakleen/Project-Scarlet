import 'package:flutter/material.dart';

import 'package:project_scarlet/presentation/standard_values.dart';

class TaskDatePicker extends StatefulWidget {
  DateTime dateTime;
  final Map<String, dynamic> formData;
  final String formDataKey;

  TaskDatePicker(this.formData, this.formDataKey, [this.dateTime]) {
    this.dateTime = this.dateTime == null ? DateTime.now() : this.dateTime;
  }

  @override
  State<StatefulWidget> createState() => _TaskDatePicker();
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
    return Padding(
      child: Column(
        children: <Widget>[
          Text('Date/Time', style: Theme.of(context).textTheme.subhead),
          SizedBox(height: 5.0),
          RaisedButton(
            color: buttonColor,
            child: Text(
              dateFormatter.format(widget.dateTime),
              style: Theme.of(context)
                  .textTheme
                  .body1
                  .copyWith(color: Theme.of(context).backgroundColor),
            ),
            onPressed: () => _selectDateTime(
                  context,
                  widget.dateTime,
                  TimeOfDay(
                    hour: widget.dateTime.hour,
                    minute: widget.dateTime.minute,
                  ),
                ),
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
            buttonColor = Theme.of(context).buttonColor;
          } else
            buttonColor = Colors.redAccent;
        });
      }
    }
  }
}
