import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:flutter_gym_app/Util/distance_time_input.dart';
import 'package:flutter_gym_app/Util/tile_type_helper.dart';
import 'package:flutter_gym_app/Util/time_input.dart';
import 'package:flutter_gym_app/Util/weight_rep_input.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AddExercisePage extends StatefulWidget {
  final String exerciseName;
  final DateTime currentDate;

  const AddExercisePage(
      {super.key, required this.exerciseName, required this.currentDate});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  late ExerciseDatabase db;
  List<bool> activeTilesList = [];
  bool addButtonActive = false;

  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minsController = TextEditingController();
  TextEditingController secsController = TextEditingController();
  TextEditingController distController = TextEditingController();

  late StreamSubscription<BoxEvent> hiveListener;

  @override
  void initState() {
    super.initState();

    reinitDB();

    weightController.text = '20';
    repsController.text = '8';
    hoursController.text = '0';
    minsController.text = '0';
    secsController.text = '0';
    distController.text = '0';

    addButtonListener();
    weightController.addListener(addButtonListener);
    repsController.addListener(addButtonListener);
    hoursController.addListener(addButtonListener);
    minsController.addListener(addButtonListener);
    secsController.addListener(addButtonListener);
    distController.addListener(addButtonListener);

    // listen for changes in the database and update page
    hiveListener = Hive.box('hivebox').watch().listen((event) {
      reinitDB();
    });
  }

  // Initialise the database and get any current data
  void reinitDB() {
    setState(() {
      db = ExerciseDatabase(
          exerciseName: widget.exerciseName, currentDate: widget.currentDate);
      activeTilesList =
          List.filled(db.currentDayLog.sets.length, false, growable: true);
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    repsController.dispose();
    hoursController.dispose();
    minsController.dispose();
    secsController.dispose();
    distController.dispose();

    hiveListener.cancel();

    super.dispose();
  }

  // Return input component based on weight/reps OR distance/time OR time
  Widget inputSelector() {
    if (db.exercise.exerciseType == ExerciseType.cardio) {
      return DistanceTimeInput(
          distController: distController,
          hoursController: hoursController,
          minsController: minsController,
          secsController: secsController);
    } else if (db.exercise.exerciseType == ExerciseType.static) {
      return TimeInput(
        hoursController: hoursController,
        minsController: minsController,
        secsController: secsController,
        compact: false,
      );
    } else {
      return WeightSetInput(
        weightController: weightController,
        repsController: repsController,
      );
    }
  }

  // Add set to list
  void addSet() {
    ExerciseSet newSet = ExerciseSet();

    if (db.exercise.exerciseType == ExerciseType.cardio) {
      newSet.distance = double.parse(distController.text);
      newSet.duration = Duration(
        hours: int.parse(hoursController.text),
        minutes: int.parse(minsController.text),
        seconds: int.parse(secsController.text),
      );
    } else if (db.exercise.exerciseType == ExerciseType.static) {
      newSet.duration = Duration(
        hours: int.parse(hoursController.text),
        minutes: int.parse(minsController.text),
        seconds: int.parse(secsController.text),
      );
    } else {
      newSet.weight = double.parse(weightController.text);
      newSet.reps = int.parse(repsController.text);
    }

    setState(() {
      db.currentDayLog.sets.add(newSet);
      activeTilesList.add(false);

      // update database
      db.addDayLog();
    });
  }

  // Delete set from list
  void deleteSet() {
    setState(() {
      db.currentDayLog.sets.removeAt(activeTilesList.indexOf(true));
      activeTilesList.removeAt(activeTilesList.indexOf(true));

      // update database
      db.deleteDayLog();
    });
  }

  // Update set
  void updateSet(int index) {
    ExerciseSet newSet = ExerciseSet();

    if (db.exercise.exerciseType == ExerciseType.cardio) {
      newSet.distance = double.parse(distController.text);
      newSet.duration = Duration(
        hours: int.parse(hoursController.text),
        minutes: int.parse(minsController.text),
        seconds: int.parse(secsController.text),
      );
    } else if (db.exercise.exerciseType == ExerciseType.static) {
      newSet.duration = Duration(
        hours: int.parse(hoursController.text),
        minutes: int.parse(minsController.text),
        seconds: int.parse(secsController.text),
      );
    } else {
      newSet.weight = double.parse(weightController.text);
      newSet.reps = int.parse(repsController.text);
    }

    setState(() {
      db.currentDayLog.sets[index] = newSet;
      updateActiveList(-1);

      // update database
      db.addDayLog();
    });
  }

  // Update the input to reflect tile and change active tiles list
  void onTileSelected(int index) {
    setState(() {
      if (db.exercise.exerciseType == ExerciseType.cardio) {
        String formatedDistance =
            NumberFormat('0.###').format(db.currentDayLog.sets[index].distance);
        distController.text = formatedDistance;
        hoursController.text =
            db.currentDayLog.sets[index].duration.inHours.toString();
        minsController.text =
            getMinuteDuration(db.currentDayLog.sets[index].duration).toString();
        secsController.text =
            getSecondDuration(db.currentDayLog.sets[index].duration).toString();
      } else if (db.exercise.exerciseType == ExerciseType.static) {
        hoursController.text =
            db.currentDayLog.sets[index].duration.inHours.toString();
        minsController.text =
            getMinuteDuration(db.currentDayLog.sets[index].duration).toString();
        secsController.text =
            getSecondDuration(db.currentDayLog.sets[index].duration).toString();
      } else {
        String formatedWeight =
            NumberFormat('0.###').format(db.currentDayLog.sets[index].weight);
        weightController.text = formatedWeight;
        repsController.text = db.currentDayLog.sets[index].reps.toString();
      }

      updateActiveList(index);
    });
  }

  // Set selected tile as active
  void updateActiveList(int index) {
    // if index is -1 reset all bools to false
    if (index == -1) {
      activeTilesList =
          List.filled(activeTilesList.length, false, growable: true);
      return;
    }
    // make current active false
    if (activeTilesList[index]) {
      activeTilesList[index] = false;
    } else {
      // reset all the bools to false
      activeTilesList =
          List.filled(activeTilesList.length, false, growable: true);

      // set only index to true
      activeTilesList[index] = true;
    }
  }

  // Check if tile has been clicked
  bool hasActive() {
    for (var element in activeTilesList) {
      if (element) return true;
    }
    return false;
  }

  // Return the first true selected tile index
  int getActiveIndex() {
    return activeTilesList.indexOf(true);
  }

  void addButtonListener() {
    setState(() {
      addButtonActive = false;
      if (db.exercise.exerciseType == ExerciseType.cardio) {
        if (nonZeroChecker(distController.text) &&
            (nonZeroChecker(hoursController.text) ||
                nonZeroChecker(minsController.text) ||
                nonZeroChecker(secsController.text))) {
          addButtonActive = true;
        }
      } else if (db.exercise.exerciseType == ExerciseType.static) {
        if (nonZeroChecker(hoursController.text) ||
            nonZeroChecker(minsController.text) ||
            nonZeroChecker(secsController.text)) {
          addButtonActive = true;
        }
      } else {
        // ExerciseType.weights
        if (nonZeroChecker(weightController.text) ||
            nonZeroChecker(repsController.text)) {
          addButtonActive = true;
        }
      }
    });
  }

  // Return true if string has non zero number
  bool nonZeroChecker(String text) {
    double? number = double.tryParse(text);
    if (number != null) {
      return number != 0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Display based on exercise category
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: inputSelector(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 80,
                  child: OutlinedButton(
                    onPressed: addButtonActive
                        ? () {
                            hasActive()
                                ? updateSet(getActiveIndex())
                                : addSet();
                          }
                        : null,
                    child: Text((hasActive() ? 'Update' : 'Add')),
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: OutlinedButton(
                    onPressed: hasActive() ? deleteSet : null,
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
            // ListView of sets
            Expanded(
              child: Scrollbar(
                child: ListView.builder(
                  itemCount: db.currentDayLog.sets.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      // Display tiles based on exercise category
                      child: TileTypeHelper(
                        exercise: db.exercise,
                        exerciseSet: db.currentDayLog.sets[index],
                        index: index,
                        activeTile: activeTilesList[index],
                      ),
                      onTap: () {
                        onTileSelected(index);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
