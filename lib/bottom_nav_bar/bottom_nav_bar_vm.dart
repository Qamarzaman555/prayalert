import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../home/home_vu.dart';

class BottomNavigationBarVM extends BaseViewModel {
  int selectedIndex = 0;
  List<Widget> screenNames = [
    const HomeVU(),
    const Text('Prayer goes here'),
    const Text('Support Us'),
    const Text('Setting'),
  ];

  void onItemTapped(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}
