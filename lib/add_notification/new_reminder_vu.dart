import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'new_reminder_vm.dart';
import '../models/prayer_model.dart';

class AddVU extends StackedView<AddVM> {
  const AddVU({super.key});

  @override
  Widget builder(BuildContext context, AddVM viewModel, Widget? child) {
    final prayerController = TextEditingController();
    final timeController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: prayerController,
            decoration: const InputDecoration(labelText: 'Prayer Name'),
          ),
          TextField(
            controller: timeController,
            decoration: const InputDecoration(labelText: 'Time (HH:mm)'),
            keyboardType: TextInputType.datetime,
          ),
          ElevatedButton(
            onPressed: () {
              final prayerName = prayerController.text;
              final timeText = timeController.text;

              if (prayerName.isEmpty || timeText.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill in all fields')),
                );
                return;
              }

              final timeParts = timeText.split(':');
              if (timeParts.length != 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid time format')),
                );
                return;
              }

              final hour = int.tryParse(timeParts[0]);
              final minute = int.tryParse(timeParts[1]);

              if (hour == null || minute == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid time values')),
                );
                return;
              }

              final now = DateTime.now();
              final dateTime =
                  DateTime(now.year, now.month, now.day, hour, minute);

              final prayerModel = PrayerModel(
                prayerName: prayerName,
                timestamp: Timestamp.fromDate(dateTime),
                onOff: true,
              );

              viewModel.addReminder(context, prayerModel);
            },
            child: const Text('Set Prayer Time'),
          ),
        ],
      ),
    );
  }

  @override
  AddVM viewModelBuilder(BuildContext context) => AddVM();
}
