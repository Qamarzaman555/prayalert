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
          // const AddVU(),
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

                List<DataRow> dataRows =
                    snapshot.data!.docs.map<DataRow>((doc) {
                  String name = doc.get('prayerName');
                  DateTime date = (doc.get('timestamp') as Timestamp).toDate();
                  String formattedTime = DateFormat.jm().format(date);
                  bool on = doc.get('onOff');

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
                  );
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        sortColumnIndex: 0,
                        sortAscending: false,
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {

      //     viewModel.sendTestNotification();
      //   },
      //   child: const Icon(Icons.notification_important),
      // ),
    );
  }

  @override
  HomeVM viewModelBuilder(BuildContext context) => HomeVM(context);
}
