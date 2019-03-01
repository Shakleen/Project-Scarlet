import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './task_model.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with TaskModel {
  static final DateFormat dateFormatter =
      DateFormat("EEEE, dd/MM/yyyy 'at' hh:mm a");
  static final Map<int, List<dynamic>> notificationDetails = {
    0: [
      AndroidNotificationDetails(
        'Project Scarlet Strategy',
        'Task notifications',
        'Notify about upcoming tasks',
        importance: Importance.High,
        priority: Priority.High,
        color: Colors.orange,
        playSound: true,
        enableVibration: true,
        onlyAlertOnce: true,
        groupKey: 'Tasks',
        channelShowBadge: true,
        style: AndroidNotificationStyle.Default,
      ),
      IOSNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    ],
  };
}
