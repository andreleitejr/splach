import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splach/app.dart';
import 'package:splach/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // await AuthRepository().signOut();
  runApp(const App());
}
