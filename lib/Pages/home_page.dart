import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
import 'package:flutter_gym_app/Pages/exercises_page.dart';
import 'package:flutter_gym_app/Pages/exercises_tabview.dart';
import 'package:flutter_gym_app/Pages/routines_page.dart';
import 'package:flutter_gym_app/Util/exercise_day_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DayDatabase db = DayDatabase(DateTime.now());
  late StreamSubscription<BoxEvent> hiveListener;

  @override
  void initState() {
    super.initState();

    // listen for changes in the database and update page
    hiveListener = Hive.box('hivebox').watch().listen((event) {
      reinitPage();
    });
  }

  // Update database and redraw widgets
  void reinitPage() {
    setState(() {
      db.updateDatabase();
    });
  }

  @override
  void dispose() {
    hiveListener.cancel();

    super.dispose();
  }

  void addDay() {
    setState(() {
      db.setDay(db.currentDate.add(const Duration(days: 1)));
    });
  }

  void subtractDay() {
    setState(() {
      db.setDay(db.currentDate.subtract(const Duration(days: 1)));
    });
  }

  void resetDate() {
    setState(() {
      db.setDay(DateTime.now());
    });
  }

  // Open AddExercise page when day tile is clicked
  // Redraw state when poping back to home page
  void dayTileOnTap(String name, DateTime currentDate) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ExercisesTabView(
            exerciseName: name,
            currentDate: currentDate,
          );
        },
      ),
    ).then((value) => reinitPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gym App"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: subtractDay,
                  icon: const Icon(Icons.chevron_left),
                  splashRadius: 20,
                ),
                GestureDetector(
                  onTap: resetDate,
                  child: Text(
                    DateFormat('EEEE dd/MM').format(db.currentDate),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  onPressed: DateUtils.isSameDay(db.currentDate, DateTime.now())
                      ? null
                      : addDay,
                  icon: const Icon(Icons.chevron_right),
                  splashRadius: 20,
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const RoutinesPage();
                    },
                  ),
                );
              },
              child: const Text("Routines"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return ExercisesPage(
                        currentDate: db.currentDate,
                      );
                    },
                  ),
                ).then((value) => reinitPage());
              },
              child: const Text("Exercises"),
            ),
            Expanded(
              child: Scrollbar(
                child: DayTile(
                  db: db,
                  dayTileOnTap: dayTileOnTap,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
