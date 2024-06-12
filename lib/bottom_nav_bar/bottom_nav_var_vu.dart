import 'package:flutter/material.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:stacked/stacked.dart';

import '../constants/app_colors.dart';
import '../constants/utils.dart';
import 'bottom_nav_bar_vm.dart';

class BottomNavigationVU extends StackedView<BottomNavigationBarVM> {
  const BottomNavigationVU({super.key});

  @override
  Widget builder(
      BuildContext context, BottomNavigationBarVM viewModel, Widget? child) {
    return Scaffold(
      body: Center(
        child: viewModel.screenNames.elementAt(viewModel.selectedIndex),
      ),
      bottomNavigationBar: FlashyTabBar(
        height: 55,
        iconSize: 24,
        selectedIndex: viewModel.selectedIndex,
        showElevation: true,
        onItemSelected: (index) {
          viewModel.onItemTapped(index);
        },
        items: [
          falshyTabBatItem('Home', 'assets/icons/home.png'),
          falshyTabBatItem('Prayer', 'assets/icons/prayer.png'),
          falshyTabBatItem('Support Us', 'assets/icons/support.png'),
          falshyTabBatItem('Setting', 'assets/icons/setting.png'),
        ],
      ),
    );
  }

  FlashyTabBarItem falshyTabBatItem(String label, String image) {
    return FlashyTabBarItem(
      activeColor: AppColors.selectedIconColor,
      inactiveColor: AppColors.nonSelectedIconColor,
      icon: customImage(image),
      title: Text(label),
    );
  }

  @override
  BottomNavigationBarVM viewModelBuilder(BuildContext context) =>
      BottomNavigationBarVM();
}
