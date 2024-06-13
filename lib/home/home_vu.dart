import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:prayalert/constants/utils.dart';
import '../constants/app_colors.dart';
import 'home_vm.dart';

class HomeVU extends StackedView<HomeVM> {
  const HomeVU({super.key});

  @override
  Widget builder(BuildContext context, HomeVM viewModel, Widget? child) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: appBar(context),
      body: Column(
        children: [
          headerImage(context),
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

                List<DataRow> dataRows =
                    viewModel.buildDataRows(snapshot, context);

                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: AppColors.backgroundColor,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowHeight: 70,
                        sortColumnIndex: 0,
                        sortAscending: true,
                        columnSpacing: MediaQuery.sizeOf(context).width * 0.07,
                        columns: [
                          DataColumn(label: customText('Prayers')),
                          DataColumn(label: customText('Jamat')),
                          DataColumn(label: customText('Duration')),
                          DataColumn(label: customText('Status')),
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

  Widget customText(String text) {
    return Text(text, style: const TextStyle(fontWeight: FontWeight.bold));
  }

  Widget headerImage(BuildContext context) {
    return Container(
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
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
      title: const Text('On Prayer'),
      centerTitle: true,
      bottom: PreferredSize(
          preferredSize: Size(MediaQuery.sizeOf(context).width, 0.6),
          child: const Divider(
            color: AppColors.dividerColor,
          )),
    );
  }

  @override
  HomeVM viewModelBuilder(BuildContext context) => HomeVM(context);
}
