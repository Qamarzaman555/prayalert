import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'bottom_nav_bar/bottom_nav_var_vu.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomNavigationVU(),
    ),
  );
}
