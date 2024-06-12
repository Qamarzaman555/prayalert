import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/prayer_model.dart';
import '../notification_services/notifications.dart';

class AddReminderVM extends BaseViewModel {
  final prayerController = TextEditingController();
  final timeController = TextEditingController();
  final minutesController = TextEditingController();
  DateTime dateTime = DateTime.now();

  AddReminderVM();

  Future<void> addOrUpdateReminder(
      BuildContext context, PrayerModel prayer) async {
    setBusy(true);
    try {
      // Assign sort order directly based on the prayer name
      switch (prayer.prayerName) {
        case 'Fajar':
          prayer.sortOrder = 1;
          break;
        case 'Zuhur':
          prayer.sortOrder = 2;
          break;
        case 'Asar':
          prayer.sortOrder = 3;
          break;
        case 'Maghrib':
          prayer.sortOrder = 4;
          break;
        case 'Isha':
          prayer.sortOrder = 5;
          break;
        case 'Jumma':
          prayer.sortOrder = 6;
          break;
        default:
          prayer.sortOrder = 7;
      }

      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(prayer.prayerName)
          .set(prayer.toJson());

      DateTime notificationTime = prayer.timestamp!
          .toDate()
          .subtract(Duration(minutes: prayer.minutesBefore!));

      Notifications.showNotifications(
        dateTime: notificationTime,
        title: 'Prayer Reminder',
        body: '${prayer.prayerName} time',
        payload: 'prayer_reminder',
      );

      debugPrint('Reminder Added');
    } catch (e) {
      debugPrint('Not Added: $e');
    }
    setBusy(false);
  }
}
