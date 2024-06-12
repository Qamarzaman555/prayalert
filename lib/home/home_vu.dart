import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import '../add_notification/new_reminder_vu.dart';
import '../checker/check_vu.dart';
import '../notification_services/notifications.dart';
import 'home_vm.dart';

class HomeVU extends StackedView<HomeVM> {
  const HomeVU({super.key});

  @override
  Widget builder(BuildContext context, HomeVM viewModel, Widget? child) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
      ),
      body: Column(
        children: [
          const AddVU(),
          Expanded(
            child: StreamBuilder(
              stream: viewModel.reminderStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No Reminders'));
                }

                // Create and sort the data rows
                List<DataRow> dataRows =
                    snapshot.data!.docs.map<DataRow>((doc) {
                  String name = doc.get('prayerName');
                  DateTime date = (doc.get('timestamp') as Timestamp).toDate();
                  String formattedTime = DateFormat.jm().format(date);
                  bool on = doc.get('onOff');
                  int sortOrder = doc.get('sortOrder');

                  return DataRow(
                    cells: [
                      DataCell(Text(name)),
                      DataCell(Text(formattedTime)),
                      const DataCell(Text('20 Mins')),
                      DataCell(
                        Checker(
                          onOff: on,
                          timestamp: doc.get('timestamp'),
                          id: doc.id,
                          onToggle: (value) {
                            if (value) {
                              Notifications.showNotifications(
                                dateTime:
                                    date.subtract(const Duration(minutes: 20)),
                                id: snapshot.data!.docs.indexOf(doc),
                                title: 'Reminder: $name',
                                body: 'It\'s almost time to pray $name',
                              );
                            } else {
                              Notifications.cancelNotification(
                                  id: snapshot.data!.docs.indexOf(doc));
                            }
                          },
                        ),
                      ),
                    ],
                    key: ValueKey(sortOrder), // Use key for sorting
                  );
                }).toList();

                // Sort the data rows based on the sortOrder
                dataRows.sort((a, b) => (a.key as ValueKey<int>)
                    .value
                    .compareTo((b.key as ValueKey<int>).value));

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortColumnIndex: 0,
                        sortAscending: true,
                        columnSpacing: MediaQuery.sizeOf(context).width * 0.1,
                        columns: const [
                          DataColumn(label: Text('Prayers')),
                          DataColumn(label: Text('Time')),
                          DataColumn(label: Text('Duration')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: dataRows,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  HomeVM viewModelBuilder(BuildContext context) => HomeVM(context);
}
