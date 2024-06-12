import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked/stacked.dart';

import '../notification_services/notifications.dart';

class HomeVM extends BaseViewModel {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  HomeVM(context) {
    Notifications.init(context);
    listenNotifications();
  }

  Stream<QuerySnapshot> reminderStream() {
    return firestore.collection('Notifications').snapshots();
  }

  void listenNotifications() {
    Notifications.onNotifications.listen((value) {});
  }

  Future<void> sendTestNotification() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      'Test Notification',
      'This is a test notification',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}
