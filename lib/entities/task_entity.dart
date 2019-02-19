import 'package:flutter/material.dart';

/// An entity class that represents a single task.
///
/// Each task in the strategic portion consists of the following things:
/// [name], [dueDate], [description], [priority] and [location]. But only
/// the first two are required to create a task while the others are
/// optional.
///
/// [priority] values are (0, low), (1, normal), (2, important), (3, urgent)
class TaskEntity {
  String _name;
  DateTime _dueDate;
  String _description;
  int _priority;
  String _location;

  // TaskEntity(
  //     {@required String name,
  //     @required DateTime dueDate,
  //     String description = 'None',
  //     int priority = 0,
  //     String location = 'Unspecified'}) {
  //   this._name = name;
  //   this._dueDate = dueDate;
  //   this._description = description;
  //   this._priority = priority;
  //   this._location = location;
  // }

  TaskEntity(this._name, this._dueDate,
      [this._description, this._priority, this._location]);

  String getName() {
    return this._name;
  }

  bool setName(String name) {
    if (name != null) {
      if (name.length > 0) {
        this._name = name;
        return true;
      }
    }
    return false;
  }

  DateTime getDueDate() {
    return this._dueDate;
  }

  bool setDate(DateTime dueDate) {
    if (dueDate != null) {
      if (dueDate.compareTo(DateTime.now()) >= 0) {
        this._dueDate = dueDate;
        return true;
      }
    }
    return false;
  }

  String getDescription() {
    return this._description;
  }

  bool setDescription(String description) {
    if (description != null) {
      if (description.length > 0) {
        this._description = description;
        return true;
      }
    }
    return false;
  }

  int getPriority() {
    return this._priority;
  }

  bool setPriority(int priority) {
    if (priority >= 0 && priority <= 3) {
      this._priority = priority;
      return true;
    }
    return false;
  }

  String getLocation() {
    return this._location;
  }

  bool setLocation(String location) {
    if (location != null) {
      if (location.length > 0) {
        this._location = location;
        return true;
      }
    }
    return false;
  }
}
