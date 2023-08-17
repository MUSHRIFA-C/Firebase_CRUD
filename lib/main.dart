import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase.dart';
Future main() async { //async fun returns the type future
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: FirebaseCrud(),
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue
    ),

  ));
}