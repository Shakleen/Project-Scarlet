import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../entities/task_entity.dart';
import '../scoped_model/main_model.dart';

class TaskNotification {
  FlutterLocalNotificationsPlugin notificationsPlugin;

  TaskNotification() {
    notificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    IOSInitializationSettings iOS = IOSInitializationSettings();
    InitializationSettings initializationSettings =
        InitializationSettings(android, iOS);
    notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (String value) {},
    );
  }

  scheduleNotification(TaskEntity task) async {
    DateTime scheduledNotificationDateTime =
        task.dueDate.subtract(Duration(minutes: 5));
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      MainModel.notificationDetails[0][0],
      MainModel.notificationDetails[0][1],
    );

    await notificationsPlugin.schedule(
      generateID(task),
      task.name,
      'Scheduled at ' + MainModel.dateFormatter.format(task.dueDate),
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  // cancelNotification(TaskEntity task) async {
  //   await notificationsPlugin.cancel(task.)
  // }

  int generateID(TaskEntity task) {
    final int upperLimit = 4294967295, mod = 4294967296;
    int finalSeed = 0, tempSeed1 = 0, tempSeed2 = 0, temp = 0;
    
    for (int i = 0; i < 8; ++i) {
      if (i == 0) {
        tempSeed1 = task.dueDate.microsecond;
        tempSeed2 = task.setDate.microsecond;
      } else if (i == 1) {
        tempSeed1 = task.dueDate.millisecond;
        tempSeed2 = task.setDate.millisecond;
      } else if (i == 2) {
        tempSeed1 = task.dueDate.second;
        tempSeed2 = task.setDate.second;
      } else if (i == 3) {
        tempSeed1 = task.dueDate.minute;
        tempSeed2 = task.setDate.minute;
      } else if (i == 4) {
        tempSeed1 = task.dueDate.hour;
        tempSeed2 = task.setDate.hour;
      } else if (i == 5) {
        tempSeed1 = task.dueDate.day;
        tempSeed2 = task.setDate.day;
      } else if (i == 6) {
        tempSeed1 = task.dueDate.month;
        tempSeed2 = task.setDate.month;
      } else {
        tempSeed1 = task.dueDate.year;
        tempSeed2 = task.setDate.year;
      }

      temp = (Random(tempSeed1).nextInt(upperLimit) + Random(tempSeed2).nextInt(upperLimit)) % mod;
      finalSeed = (finalSeed + temp) % mod;
    }

    return Random(finalSeed).nextInt(upperLimit);
  }
}
