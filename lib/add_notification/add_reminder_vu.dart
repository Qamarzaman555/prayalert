import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:prayalert/constants/utils.dart';
import 'package:stacked/stacked.dart';
import '../models/prayer_model.dart';
import 'add_reminder_vm.dart';

class AddReminderVU extends StackedView<AddReminderVM> {
  const AddReminderVU({super.key});

  @override
  Widget builder(BuildContext context, AddReminderVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Prayer time'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customTextField(viewModel.prayerController, 'Prayer Name'),
              8.spaceY,
              customTextField(viewModel.timeController, 'Time (HH:mm)'),
              8.spaceY,
              customTextField(viewModel.minutesController, 'Minutes Before'),
              8.spaceY,
              ElevatedButton(
                onPressed: () {
                  final prayerName = viewModel.prayerController.text;
                  final timeText = viewModel.timeController.text;
                  final minutesBefore = viewModel.minutesController.text;

                  if (prayerName.isEmpty ||
                      timeText.isEmpty ||
                      minutesBefore.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please fill in all fields')),
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

                  final minutes = int.tryParse(minutesBefore);

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
                    minutesBefore: minutes,
                  );

                  viewModel.addOrUpdateReminder(context, prayerModel);
                },
                child: const Text('Set Prayer Time'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField customTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  AddReminderVM viewModelBuilder(BuildContext context) => AddReminderVM();
}
