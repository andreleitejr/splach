import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splach/app.dart';
import 'package:splach/firebase_options.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const App());
}