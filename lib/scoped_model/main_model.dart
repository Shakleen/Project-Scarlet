import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './task_model.dart';
import '../presentation/custom_icons.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with TaskModel {
  static final DateFormat dateFormatter =
      DateFormat("EEEE, dd/MM/yyyy 'at' hh:mm a");
  static final TextStyle labelStyle =
      TextStyle(color: Colors.blueAccent, fontFamily: 'Roboto', fontSize: 16);
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
  static final Map<String, List<dynamic>> navigationRoutes = const {
    'home': ['/', Icons.home, Colors.blue],
    'strength' : ['/strength', CustomIcons.fist_raised_solid, Colors.red],
    'wisdom' : ['/wisdom', CustomIcons.book_solid, Colors.green],
    'resistance': ['/resistance', CustomIcons.shield_alt_solid, Colors.purple],
    'strategic' : ['/strategic', CustomIcons.chess_knight_solid, Colors.deepOrangeAccent],
    'play game' : ['/playgame', CustomIcons.gamepad_solid, Colors.indigoAccent],
    'settings': ['/settings', Icons.settings, Colors.black],
    'about' : ['/about', Icons.info, Colors.blueAccent],
  };
}
