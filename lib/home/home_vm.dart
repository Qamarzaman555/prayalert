import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked/stacked.dart';

import '../constants/utils.dart';
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

  Widget getPrayerIcon(DateTime dateTime) {
    int hour = dateTime.hour;

    if (hour >= 2 && hour < 8) {
      return customImage('assets/icons/fajar.png'); // Fajr
    } else if (hour >= 8 && hour < 15) {
      return customImage('assets/icons/zuhr.png'); // Dhuhr
    } else if (hour >= 15 && hour < 18) {
      return customImage('assets/icons/asar.png'); // Asr
    } else if (hour >= 18 && hour < 19) {
      return customImage('assets/icons/maghrib.png'); // Maghrib
    } else if (hour >= 19 && hour < 24) {
      return customImage('assets/icons/isha.png',
          height: 16.0, width: 16.0); // Isha
    } else {
      return const Icon(Icons.access_time); // Default icon for other times
    }
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
