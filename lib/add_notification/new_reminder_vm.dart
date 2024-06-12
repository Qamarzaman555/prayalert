import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/prayer_model.dart';
import '../notification_services/notifications.dart';

class AddVM extends BaseViewModel {
  DateTime dateTime = DateTime.now();

  AddVM();

  Future<void> addOrUpdateReminder(
      BuildContext context, PrayerModel prayer) async {
    setBusy(true);
    try {
      // Assign int to prayer names for sorting
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

      DateTime notificationTime =
          prayer.timestamp!.toDate().subtract(const Duration(minutes: 20));

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
