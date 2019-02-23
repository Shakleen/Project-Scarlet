import 'package:flutter/material.dart';

/// An entity class that represents a single task.
///
/// Each task in the strategic portion consists of the following things:
/// [name], [dueDate], [completeDate], [description], [priority] and [location].
/// But only the first two are required to create a task while the others are
/// optional.
///
/// [priority] values are (0, low), (1, normal), (2, important), (3, urgent)
class TaskEntity {
  String _id;
  String _name;
  DateTime _dueDate;
  DateTime _completeDate;
  String _description;
  int _priority;
  String _location;
  DateTime _setDate;

  TaskEntity({
    @required String id,
    @required String name,
    @required DateTime dueDate,
    String description = null,
    int priority = 0,
    String location = null,
  }) {
    this._id = id;
    this._name = name;
    this._dueDate = dueDate;
    this._setDate = DateTime.now();
    this._description = description;
    this._priority = priority;
    this._location = location;
    this._completeDate = null;
  }

  dynamic getInfo(int i) {
    switch (i) {
      case 0:
        return this.getID();
      case 1:
        return this.getName();
      case 2:
        return this.getDueDate();
      case 3:
        return this.getDescription();
      case 4:
        return this.getPriority();
      case 5:
        return this.getLocation();
      case 6:
        return this.getCompleteDate();
      case 7:
        return this.getSetDate();
    }
    return null;
  }

  String getID() {
    return this._id;
  }

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

  bool setDueDate(DateTime dueDate) {
    if (dueDate != null) {
      if (dueDate.compareTo(DateTime.now()) >= 0) {
        this._dueDate = dueDate;
        return true;
      }
    }
    return false;
  }

  DateTime getCompleteDate() {
    return this._completeDate;
  }

  bool setCompleteDate(DateTime completeDate) {
    if (completeDate != null) {
      this._completeDate = completeDate;
      return true;
    }
    return false;
  }

  DateTime getSetDate() {
    return this._setDate;
  }

  bool setSetDate(DateTime setDate) {
    if (setDate != null) {
      this._setDate = setDate;
      return true;
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
