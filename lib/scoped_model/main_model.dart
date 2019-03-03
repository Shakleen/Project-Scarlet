import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import './task_model.dart';
import '../presentation/custom_icons.dart';
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
  static final Map<String, List<dynamic>> navigationRoutes = const {
    'home': ['/', Icons.home],
    'strength': ['/strength', CustomIcons.fist_raised_solid],
    'wisdom': ['/wisdom', CustomIcons.book_solid],
    'resistance': ['/resistance', CustomIcons.shield_alt_solid],
    'strategic': ['/strategic', CustomIcons.chess_knight_solid],
    'play game': ['/playgame', CustomIcons.gamepad_solid],
    'settings': ['/settings', Icons.settings],
    'about': ['/about', Icons.info],
  };
  static ThemeData defaultTheme = ThemeData(
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
      backgroundColor: Colors.white,
      fontFamily: 'Roboto',
      brightness: Brightness.light,
      accentColorBrightness: Brightness.light,
      textTheme: TextTheme(
        title: TextStyle(color: Colors.white),
        subtitle: TextStyle(color: Colors.black),
        subhead: TextStyle(color: Colors.blueAccent),
        body1: TextStyle(color: Colors.black),
      ),
      iconTheme: IconThemeData(color: Colors.white70, size: 26),
      secondaryHeaderColor: Colors.black,
      buttonColor: Colors.blue,
    );
}
