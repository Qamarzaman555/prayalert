import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../models/prayer_model.dart';
import 'new_reminder_vm.dart';

class AddVU extends StackedView<AddVM> {
  const AddVU({super.key});

  @override
  Widget builder(BuildContext context, AddVM viewModel, Widget? child) {
    final prayerController = TextEditingController();
    final timeController = TextEditingController();
    final minutesController = TextEditingController(); // Add a new controller

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
          TextField(
            controller: minutesController, // Attach the controller
            decoration: const InputDecoration(labelText: 'Minutes Before'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: () {
              final prayerName = prayerController.text;
              final timeText = timeController.text;
              final minutesBefore = minutesController.text; // Capture the input

              if (prayerName.isEmpty ||
                  timeText.isEmpty ||
                  minutesBefore.isEmpty) {
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

              final minutes =
                  int.tryParse(minutesBefore); // Parse minutesBefore

              if (hour == null || minute == null || minutes == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid input values')),
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
                minutesBefore: minutes, // Set minutesBefore
              );

              viewModel.addOrUpdateReminder(context, prayerModel);
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
