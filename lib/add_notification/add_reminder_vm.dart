import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../constants/utils.dart';
import '../models/prayer_model.dart';
import '../notification_services/notifications.dart';

class AddReminderVM extends BaseViewModel {
  final List<String> prayerNames = [
    'Fajar',
    'Zuhur',
    'Asar',
    'Maghrib',
    'Isha',
    'Jumma'
  ];
  String? selectedPrayerName;
  final timeController = TextEditingController();
  final minutesController = TextEditingController();
  DateTime dateTime = DateTime.now();

  AddReminderVM(BuildContext context) {
    Notifications.init(context);
    listenNotifications();
  }

  void listenNotifications() {
    Notifications.onNotifications.listen((value) {});
  }

  void setSelectedPrayerName(String? name) {
    selectedPrayerName = name;
    notifyListeners();
  }

  Future<void> addOrUpdateReminder(context) async {
    setBusy(true);
    try {
      final prayerName = selectedPrayerName;
      final timeText = timeController.text;
      final minutesBefore = minutesController.text;

      if (prayerName == null || timeText.isEmpty || minutesBefore.isEmpty) {
        Utils.toastMessage(context: context, text: 'Please fill in all fields');
        setBusy(false);
        return;
      }

      final timeParts = timeText.split(':');
      if (timeParts.length != 2) {
        Utils.toastMessage(context: context, text: 'Invalid time format');
        setBusy(false);
        return;
      }

      final hour = int.tryParse(timeParts[0]);
      final minute = int.tryParse(timeParts[1]);
      final minutes = int.tryParse(minutesBefore);

      if (hour == null || minute == null || minutes == null) {
        Utils.toastMessage(context: context, text: 'Invalid input values');
        setBusy(false);
        return;
      }

      final now = DateTime.now();
      final dateTime = DateTime(now.year, now.month, now.day, hour, minute);

      final prayer = PrayerModel(
        prayerName: prayerName,
        timestamp: Timestamp.fromDate(dateTime),
        onOff: true,
        minutesBefore: minutes,
      );

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
          prayer.sortOrder = DateTime.now().millisecondsSinceEpoch;
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
      Utils.toastMessage(context: context, text: 'Reminder Added');
      debugPrint('Reminder Added');
    } catch (e) {
      Utils.toastMessage(context: context, text: 'Something Went Wrong...');
      debugPrint('Not Added: $e');
    }
    setBusy(false);
  }
}
