import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:flutter_gym_app/Pages/main_page.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // init hive
  await Hive.initFlutter();

  // register hive adapters
  Hive.registerAdapter(ExerciseDayLogAdapter());
  Hive.registerAdapter(ExerciseSetAdapter());

  // open hive box
  await Hive.openBox('hivebox');

  // get exercises from JSON file
  await readJSON();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MainPage(),
    );
  }
}
