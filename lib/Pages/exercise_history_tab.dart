import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
import 'package:flutter_gym_app/Util/exercise_day_tile.dart';
import 'package:flutter_gym_app/Util/exercise_history_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExerciseHistoryTab extends StatefulWidget {
  final String exerciseName;

  const ExerciseHistoryTab({
    super.key,
    required this.exerciseName,
  });

  @override
  State<ExerciseHistoryTab> createState() => _ExerciseHistoryTabState();
}

class _ExerciseHistoryTabState extends State<ExerciseHistoryTab> {
  late ExerciseDatabase db;
  late StreamSubscription<BoxEvent> hiveListener;

  @override
  void initState() {
    super.initState();

    reinit();

    // listen for changes in the database and update page
    hiveListener = Hive.box('hivebox').watch().listen((event) {
      reinit();
    });
  }

  void reinit() {
    setState(() {
      db = ExerciseDatabase(
        exerciseName: widget.exerciseName,
        currentDate: DateTime.now(),
      );
    });
  }

  @override
  void dispose() {
    hiveListener.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return db.exerciseLog.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'There are no recorded sets for this exercise',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : Scrollbar(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                          flex: 1,
                          child: ExerciseHistoryTile(
                            db: db,
                            left: true,
                          )),
                      Expanded(
                          flex: 1,
                          child: ExerciseHistoryTile(
                            db: db,
                            left: false,
                          )),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: const Text(
                      'History',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: db.exerciseLog.length,
                    itemBuilder: (context, datesIndex) {
                      return Container(
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade600,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    DateFormat('EEEE, MMMM d, y').format(
                                        db.exerciseLog[datesIndex].date),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                            ExerciseDayTile(
                              dayLog: db.exerciseLog[datesIndex],
                              exerciseName: widget.exerciseName,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
  }
}
