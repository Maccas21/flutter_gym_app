import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
import 'package:flutter_gym_app/Pages/exercises_page.dart';
import 'package:flutter_gym_app/Pages/routines_page.dart';
import 'package:flutter_gym_app/Util/exercise_day_tile.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DayDatabase db = DayDatabase();

  @override
  void initState() {
    super.initState();

    db.initDB();
  }

  // update page when coming back to this page
  void reinitPage() {
    setState(() {
      db.updateDatabase();
    });
  }

  void addDay() {
    setState(() {
      db.setDay(db.currentDate.subtract(const Duration(days: 1)));
    });
  }

  void subtractDay() {
    setState(() {
      db.setDay(db.currentDate.subtract(const Duration(days: -1)));
    });
  }

  void resetDate() {
    setState(() {
      db.setDay(DateTime.now());
    });
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
                    DateFormat('EEE dd/MM').format(db.currentDate),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  onPressed: addDay,
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
                child: ListView.builder(
                  itemCount: db.currentDateExercises.length,
                  itemBuilder: ((context, index) {
                    return ExerciseDayTile(
                        dayLog: db.dayExerciseList[index],
                        exerciseName: db.currentDateExercises[index]);
                  }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
