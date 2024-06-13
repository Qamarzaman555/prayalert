import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../checker/check_vu.dart';
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

  void listenNotifications() {
    Notifications.onNotifications.listen((value) {});
  }

  Stream<QuerySnapshot> reminderStream() {
    return firestore.collection('Notifications').snapshots();
  }

  Future<void> deleteNotification(
      context, String id, int notificationId, String name) async {
    try {
      await firestore.collection('Notifications').doc(name).delete();
      await Notifications.cancelNotification(id: notificationId);
      Utils.toastMessage(context: context, text: 'Reminder Deleted');
    } catch (e) {
      Utils.toastMessage(context: context, text: 'Something Went Wrong...');
      debugPrint('Error deleting notification: $e');
    }
  }

  Widget getPrayerIcon(DateTime dateTime) {
    int hour = dateTime.hour;

    if (hour >= 2 && hour < 8) {
      return customImage('assets/icons/fajar.png');
    } else if (hour >= 8 && hour < 15) {
      return customImage('assets/icons/zuhr.png');
    } else if (hour >= 15 && hour < 18) {
      return customImage('assets/icons/asar.png');
    } else if (hour >= 18 && hour < 19) {
      return customImage('assets/icons/maghrib.png');
    } else if (hour >= 19 && hour < 24) {
      return customImage('assets/icons/isha.png', height: 16.0, width: 16.0);
    } else {
      return const Icon(Icons.access_time);
    }
  }

  Future<void> showDeleteDialog(BuildContext context, DocumentSnapshot doc,
      int index, String name) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Notification'),
          content:
              const Text('Are you sure you want to delete this notification?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteNotification(context, doc.id, index, name);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  List<DataRow> buildDataRows(
      AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return snapshot.data!.docs.map<DataRow>((doc) {
      String name = doc.get('prayerName');
      DateTime date = (doc.get('timestamp') as Timestamp).toDate();
      String formattedTime = DateFormat.jm().format(date);
      bool on = doc.get('onOff');
      int sortOrder = doc.get('sortOrder');
      int minutesBefore = doc.get('minutesBefore');

      return DataRow(
        onLongPress: () {
          showDeleteDialog(
              context, doc, snapshot.data!.docs.indexOf(doc), name);
        },
        cells: [
          DataCell(Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getPrayerIcon(date),
              4.spaceX,
              Text(name),
            ],
          )),
          DataCell(Text(formattedTime)),
          DataCell(Text('$minutesBefore Mins')),
          DataCell(
            Checker(
              onOff: on,
              timestamp: doc.get('timestamp'),
              id: doc.id,
              onToggle: (value) {
                if (value) {
                  Notifications.showNotifications(
                    dateTime: date.subtract(Duration(minutes: minutesBefore)),
                    id: snapshot.data!.docs.indexOf(doc),
                    title: 'Prayer Time: $formattedTime',
                    body: 'It\'s almost time to pray $name',
                  );
                  Utils.toastMessage(context: context, text: 'Reminder Set');
                } else {
                  Notifications.cancelNotification(
                      id: snapshot.data!.docs.indexOf(doc));
                  Utils.toastMessage(
                      context: context, text: 'Reminder Cancelled');
                }
              },
            ),
          ),
        ],
        key: ValueKey(sortOrder),
      );
    }).toList()
      ..sort((a, b) => (a.key as ValueKey<int>)
          .value
          .compareTo((b.key as ValueKey<int>).value));
  }
}
