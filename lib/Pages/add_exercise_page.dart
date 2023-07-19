import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:flutter_gym_app/Util/distance_time_input.dart';
import 'package:flutter_gym_app/Util/tile_selector_helper.dart';
import 'package:flutter_gym_app/Util/time_input.dart';
import 'package:flutter_gym_app/Util/weight_rep_input.dart';
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
  late Exercise exercise;
  late ExerciseDatabase db;
  List<bool> activeTilesList = [];

  TextEditingController weightController = TextEditingController();
  TextEditingController repsController = TextEditingController();
  TextEditingController hoursController = TextEditingController();
  TextEditingController minsController = TextEditingController();
  TextEditingController secsController = TextEditingController();
  TextEditingController distController = TextEditingController();

  @override
  void initState() {
    super.initState();

    exercise = defaultExercises.where((exerciseValue) {
      final exerciseName = exerciseValue.name.toLowerCase();
      final input = widget.exerciseName.toLowerCase();

      return exerciseName.contains(input);
    }).first;

    // initialise the database and get any current data
    db = ExerciseDatabase(
        exerciseName: exercise.name, currentDate: widget.currentDate);
    activeTilesList =
        List.filled(db.currentDayLog.sets.length, false, growable: true);

    weightController.text = '20';
    repsController.text = '8';
    hoursController.text = '0';
    minsController.text = '0';
    secsController.text = '0';
    distController.text = '0';
  }

  @override
  void dispose() {
    super.dispose();

    weightController.dispose();
    repsController.dispose();
    hoursController.dispose();
    minsController.dispose();
    secsController.dispose();
    distController.dispose();
  }

  // Return input component based on weight/reps OR distance/time OR time
  Widget inputSelector() {
    if (exercise.exerciseType == ExerciseType.cardio) {
      return DistanceTimeInput(
          distController: distController,
          hoursController: hoursController,
          minsController: minsController,
          secsController: secsController);
    } else if (exercise.exerciseType == ExerciseType.static) {
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

    if (exercise.exerciseType == ExerciseType.cardio) {
      newSet.distance = int.parse(distController.text);
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else if (exercise.exerciseType == ExerciseType.static) {
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else {
      newSet.weight = int.parse(weightController.text);
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

    if (exercise.exerciseType == ExerciseType.cardio) {
      newSet.distance = int.parse(distController.text);
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else if (exercise.exerciseType == ExerciseType.static) {
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else {
      newSet.weight = int.parse(weightController.text);
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
      if (exercise.exerciseType == ExerciseType.cardio) {
        distController.text = db.currentDayLog.sets[index].distance.toString();
        hoursController.text =
            db.currentDayLog.sets[index].durationHours.toString();
        minsController.text =
            db.currentDayLog.sets[index].durationMins.toString();
        secsController.text =
            db.currentDayLog.sets[index].durationSecs.toString();
      } else if (exercise.exerciseType == ExerciseType.static) {
        hoursController.text =
            db.currentDayLog.sets[index].durationHours.toString();
        minsController.text =
            db.currentDayLog.sets[index].durationMins.toString();
        secsController.text =
            db.currentDayLog.sets[index].durationSecs.toString();
      } else {
        weightController.text = db.currentDayLog.sets[index].weight.toString();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.name),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              DateFormat('EEEEE, MMMM dd').format(widget.currentDate),
              style: const TextStyle(fontSize: 20),
            ),
            // Display based on exercise category
            inputSelector(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 80,
                  child: OutlinedButton(
                    onPressed: () {
                      hasActive() ? updateSet(getActiveIndex()) : addSet();
                    },
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
                      child: TileSelectorHelper(
                        exercise: exercise,
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
