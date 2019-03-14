import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project_scarlet/presentation/standard_values.dart';

import '../entities/task_entity.dart';

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
    if (task.dueDate.isAfter(DateTime.now())) {
      await notificationsPlugin.schedule(
        task.id,
        task.name,
        'Scheduled at ' + dateFormatter.format(task.dueDate),
        task.dueDate.subtract(Duration(minutes: 5)),
        NotificationDetails(
          notificationDetails[0][0],
          notificationDetails[0][1],
        ),
      );
    }
  }

  cancelNotification(TaskEntity task) async =>
      await notificationsPlugin.cancel(task.id);
}
