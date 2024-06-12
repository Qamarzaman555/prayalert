import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_bar/bottom_nav_var_vu.dart';
import 'firebase_options.dart';
import 'home/home_vu.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: BottomNavigationVU(),
    );
  }
}
