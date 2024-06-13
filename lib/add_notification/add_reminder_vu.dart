import 'package:flutter/material.dart';
import 'package:prayalert/constants/utils.dart';
import 'package:stacked/stacked.dart';
import '../notification_services/notifications.dart';
import 'add_reminder_vm.dart';

class AddReminderVU extends StackedView<AddReminderVM> {
  const AddReminderVU({super.key});

  @override
  Widget builder(BuildContext context, AddReminderVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Prayer Time'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Prayer Time:', style: TextStyle(fontSize: 32)),
              Wrap(
                spacing: 8.0,
                children: viewModel.prayerNames.map((prayerName) {
                  return ChoiceChip(
                    label: Text(prayerName),
                    selected: viewModel.selectedPrayerName == prayerName,
                    onSelected: (selected) {
                      viewModel.setSelectedPrayerName(prayerName);
                    },
                  );
                }).toList(),
              ),
              16.spaceY,
              customTextField(viewModel.timeController, 'Time (HH:mm)'),
              8.spaceY,
              customTextField(viewModel.minutesController, 'Minutes Before'),
              8.spaceY,
              ElevatedButton(
                onPressed: () => viewModel.addOrUpdateReminder(context),
                child: const Text('Set Prayer Time'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Notifications.showNotifications(
            id: 0,
            title: 'Test Notification',
            body: 'This is a test notification body',
            payload: 'Test Payload',
            dateTime: DateTime.now().add(const Duration(seconds: 5)),
          );
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }

  TextField customTextField(TextEditingController controller, String label) {
    return TextField(
      keyboardType: TextInputType.datetime,
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }

  @override
  AddReminderVM viewModelBuilder(BuildContext context) =>
      AddReminderVM(context);
}
