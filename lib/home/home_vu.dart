import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:prayalert/constants/utils.dart';
import 'package:stacked/stacked.dart';
import '../checker/check_vu.dart';
import '../constants/app_colors.dart';
import '../notification_services/notifications.dart';
import 'home_vm.dart';

class HomeVU extends StackedView<HomeVM> {
  const HomeVU({super.key});

  @override
  Widget builder(BuildContext context, HomeVM viewModel, Widget? child) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: const Text('On Prayer'),
        centerTitle: true,
        bottom: PreferredSize(
            preferredSize: Size(MediaQuery.sizeOf(context).width, 0.6),
            child: const Divider(
              color: AppColors.dividerColor,
            )),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.sizeOf(context).height / 3.5,
            width: MediaQuery.sizeOf(context).width,
            decoration: const BoxDecoration(
                color: AppColors.imageBackgroundColor,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                )),
            child: const Image(
              image: AssetImage('assets/images/mosque.png'),
              fit: BoxFit.fill,
            ),
          ),
          24.spaceY,
          Flexible(
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
                  int minutesBefore = doc.get('minutesBefore');

                  return DataRow(
                    cells: [...SizedBox(height:4),
                      DataCell(Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          viewModel.getPrayerIcon(date),
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
                                dateTime: date
                                    .subtract(Duration(minutes: minutesBefore)),
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

                return Card(
                  color: AppColors.backgroundColor,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowHeight: 70,
                      sortColumnIndex: 0,
                      sortAscending: true,
                      columnSpacing: MediaQuery.sizeOf(context).width * 0.07,
                      columns: const [
                        DataColumn(label: Text('Prayers')),
                        DataColumn(label: Text('Jamat')),
                        DataColumn(label: Text('Duration')),
                        DataColumn(label: Text('Status')),
                      ],
                      rows: dataRows,
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
