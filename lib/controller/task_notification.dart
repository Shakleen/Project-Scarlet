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
    if (task.dueDate.compareTo(DateTime.now()) > 0 &&
        task.completeDate == null) {
      DateTime scheduledNotificationDateTime =
          task.dueDate.subtract(Duration(minutes: 5));
      NotificationDetails platformChannelSpecifics = NotificationDetails(
        MainModel.notificationDetails[0][0],
        MainModel.notificationDetails[0][1],
      );

      await notificationsPlugin.schedule(
        task.id,
        task.name,
        'Scheduled at ' + MainModel.dateFormatter.format(task.dueDate),
        scheduledNotificationDateTime,
        platformChannelSpecifics,
      );
    }
  }

  cancelNotification(TaskEntity task) async =>
      await notificationsPlugin.cancel(task.id);
}
