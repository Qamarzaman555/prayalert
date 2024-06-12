import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/prayer_model.dart';
import '../notification_services/notifications.dart';

class AddVM extends BaseViewModel {
  DateTime dateTime = DateTime.now();

  AddVM();

  Future<void> addReminder(BuildContext context, PrayerModel prayer) async {
    setBusy(true);
    try {
      // Update Firestore path to 'Notifications'
      await FirebaseFirestore.instance
          .collection('Notifications')
          .doc(prayer.prayerName)
          .set(prayer.toJson());

      // Schedule notification 20 minutes before prayer time
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
      debugPrint('Not Added');
    }
    setBusy(false);
  }
}
