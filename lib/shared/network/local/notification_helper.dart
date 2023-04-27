import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:my_reminder/shared/components/constants.dart';

class NotificationHelper {
  // Add single notification
  static triggerNotification(
      {required int id,
      required String title,
      required String body,
      required DateTime dateTime}) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'main_channel',
          title: title,
          body: body,
        ),
        schedule: NotificationCalendar.fromDate(date: dateTime));
  }

  // repeate notification

  static repeateNotification({
    required int id,
    required String title,
    required String body,
    required int day,
    required DateTime dateTime,
  }) {
    AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: id,
          channelKey: 'main_channel',
          title: title,
          body: body,
        ),
        schedule: NotificationCalendar(
          repeats: true,
          allowWhileIdle: true,
          year: dateTime.year,
          month: dateTime.month,
          hour: dateTime.hour,
          minute: dateTime.minute,
          weekday: day,
        ));
  }

// delete one notification
  static deleteNotification({required int id}) async {
    await AwesomeNotifications().cancel(id);
  }

// delete all notifications / pending
  static deleteAllNotifications() {
    AwesomeNotifications().cancelAll();
  }

  //
  static cancelScheduled() {
    AwesomeNotifications().cancelAllSchedules();
  }

//   //Notification Service
//   NotificationHelper notificationHelper = NotificationHelper._internal();

// // pointer to flutter local notifications package
//   static FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   NotificationHelper._internal();

//   static init() async {
//     tz.initializeTimeZones();
//     tz.setLocalLocation(
//         tz.getLocation(await FlutterNativeTimezone.getLocalTimezone()));
//     //Android intialization settings
//     final AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     //Ios intialization settings

//     final DarwinInitializationSettings iosSettings =
//         DarwinInitializationSettings();

//     // Set settings
//     final InitializationSettings initializationSettings =
//         InitializationSettings(android: androidSettings, iOS: iosSettings);

//     notificationsPlugin.initialize(initializationSettings);
//   }

//   static Future<void> showNotification(
//       int id, String? title, String? body, TZDateTime dateTime) async {
//     await notificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       dateTime,
//       const NotificationDetails(
//         // Android Details
//         android: AndroidNotificationDetails('main_channel', 'Main Channel',
//             channelDescription: "ashwin",
//             importance: Importance.max,
//             priority: Priority.max),

//         // iOS details
//         iOS: DarwinNotificationDetails(
//           sound: 'default.wav',
//           presentAlert: true,
//           presentBadge: true,
//           presentSound: true,
//         ),
//       ),
//       // Type of time interpretation
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle:
//           true, // To show notifications even when app is closed
//     );
//   }

//   static Future<void> cancelNotification(
//     int id,
//   ) async {
//     await notificationsPlugin.cancel(id);
//   }

//   static Future<void> cancelAllNotifications() async {
//     await notificationsPlugin.cancelAll();
//   }

//   // showMessage(int id, String title, String body, TZDateTime dateTime) async {
//   //   FirebaseMessaging.onMessage.listen((message) {
//   //     print(message.notification!.body);
//   //     print(message.notification!.title);
//   //   });

//   //   AndroidNotificationDetails androidPlatformChannelSpecifes =
//   //       const AndroidNotificationDetails('ddr', 'ddr',
//   //           importance: Importance.max,
//   //           priority: Priority.max,
//   //           playSound: true);

//   //   NotificationDetails platformChannelSpecifies =
//   //       NotificationDetails(android: androidPlatformChannelSpecifes);

//   //   await notificationsPlugin.zonedSchedule(
//   //     id,
//   //     title,
//   //     body,
//   //     dateTime,
//   //     const NotificationDetails(
//   //       // Android Details
//   //       android: AndroidNotificationDetails('ddr', 'ddr',
//   //           channelDescription: "ashwin",
//   //           importance: Importance.max,
//   //           priority: Priority.max),

//   //       // iOS details
//   //       iOS: DarwinNotificationDetails(
//   //         sound: 'default.wav',
//   //         presentAlert: true,
//   //         presentBadge: true,
//   //         presentSound: true,
//   //       ),
//   //     ),
//   //     // Type of time interpretation
//   //     uiLocalNotificationDateInterpretation:
//   //         UILocalNotificationDateInterpretation.absoluteTime,
//   //     androidAllowWhileIdle:
//   //         true, // To show notifications even when app is closed
//   //   );
//   // }
}
