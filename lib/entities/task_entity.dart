import 'package:flutter/material.dart';

class TaskEntity {
  String name;
  DateTime dueDate;
  String description;
  String priority;
  String location;

  TaskEntity(
      {@required String name,
      @required DateTime dueDate,
      String description = 'None',
      String priority = 'Normal',
      String location = 'Unspecified'}) {
    this.name = name;
    this.dueDate = dueDate;
    this.description = description;
    this.priority = priority;
    this.location = location;
  }

  bool setName(String name) {
    if (name.length > 0) {
      this.name = name;
      return true;
    }
    return false;
  }

  bool setDate(DateTime dueDate) {
    if (dueDate.compareTo(DateTime.now()) >= 0) {
      this.dueDate = dueDate;
      return true;
    }
    return false;
  }

  bool setDescription(String description) {
    if (description.length > 0) {
      this.description = description;
      return true;
    }
    return false;
  }

  bool setPriority(String priority) {
    if (priority.length > 0) {
      this.priority = priority;
      return true;
    }
    return false;
  }

  bool setLocation(String location) {
    if (location.length > 0) {
      this.location = location;
      return true;
    }
    return false;
  }
}
