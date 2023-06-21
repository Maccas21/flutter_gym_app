import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Util/distance_time_input.dart';
import 'package:flutter_gym_app/Util/distance_time_tile.dart';
import 'package:flutter_gym_app/Util/time_input.dart';
import 'package:flutter_gym_app/Util/time_tile.dart';
import 'package:flutter_gym_app/Util/weight_rep_input.dart';
import 'package:flutter_gym_app/Util/weight_rep_tile.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gym_app/Model/exercises.dart';

class AddExercisePage extends StatefulWidget {
  final String exerciseName;

  const AddExercisePage({super.key, required this.exerciseName});

  @override
  State<AddExercisePage> createState() => _AddExercisePageState();
}

class _AddExercisePageState extends State<AddExercisePage> {
  late Exercise exercise;
  List<ExerciseSet> listOfSets = [];
  List<bool> activeTilesList = [];
  Map<String, bool> exerciseType = {
    'Cardio': false,
    'Static': false,
    'Weights': false
  };

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

    if (exercise.category == 'cardio') {
      exerciseType['Cardio'] = true;
    } else if (exercise.force == 'static') {
      exerciseType['Static'] = true;
    } else {
      exerciseType['Weights'] = true;
    }

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
    if (exerciseType['Cardio'] == true) {
      return DistanceTimeInput(
          distController: distController,
          hoursController: hoursController,
          minsController: minsController,
          secsController: secsController);
    } else if (exerciseType['Static'] == true) {
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

  // Return tile widget based on weight/reps OR distance/time OR time
  Widget tileSelector(int index) {
    if (exerciseType['Cardio'] == true) {
      return DistanceTimeTile(
        index: index,
        distance: listOfSets[index].distance,
        hours: listOfSets[index].durationHours,
        mins: listOfSets[index].durationMins,
        secs: listOfSets[index].durationSecs,
        active: activeTilesList[index],
      );
    } else if (exerciseType['Static'] == true) {
      return TimeTile(
        index: index,
        hours: listOfSets[index].durationHours,
        mins: listOfSets[index].durationMins,
        secs: listOfSets[index].durationSecs,
        active: activeTilesList[index],
      );
    } else {
      return WeightRepTile(
        index: index,
        weight: listOfSets[index].weight,
        reps: listOfSets[index].reps,
        active: activeTilesList[index],
      );
    }
  }

  // Add set to list
  void addSet() {
    ExerciseSet newSet = ExerciseSet();

    if (exerciseType['Cardio'] == true) {
      newSet.distance = int.parse(distController.text);
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else if (exerciseType['Static'] == true) {
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else {
      newSet.weight = int.parse(weightController.text);
      newSet.reps = int.parse(repsController.text);
    }

    setState(() {
      listOfSets.add(newSet);
      activeTilesList.add(false);
    });
  }

  // Delete set from list
  void deleteSet() {
    setState(() {
      listOfSets.removeAt(activeTilesList.indexOf(true));
      activeTilesList.removeAt(activeTilesList.indexOf(true));
    });
  }

  // Update set
  void updateSet(int index) {
    ExerciseSet newSet = ExerciseSet();

    if (exerciseType['Cardio'] == true) {
      newSet.distance = int.parse(distController.text);
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else if (exerciseType['Static'] == true) {
      newSet.durationHours = int.parse(hoursController.text);
      newSet.durationMins = int.parse(minsController.text);
      newSet.durationSecs = int.parse(secsController.text);
    } else {
      newSet.weight = int.parse(weightController.text);
      newSet.reps = int.parse(repsController.text);
    }

    setState(() {
      listOfSets[index] = newSet;
    });
  }

  // Update the input to reflect tile and change active tiles list
  void onTileSelected(int index) {
    setState(() {
      if (exerciseType['Cardio'] == true) {
        distController.text = listOfSets[index].distance.toString();
        hoursController.text = listOfSets[index].durationHours.toString();
        minsController.text = listOfSets[index].durationMins.toString();
        secsController.text = listOfSets[index].durationSecs.toString();
      } else if (exerciseType['Static'] == true) {
        hoursController.text = listOfSets[index].durationHours.toString();
        minsController.text = listOfSets[index].durationMins.toString();
        secsController.text = listOfSets[index].durationSecs.toString();
      } else {
        weightController.text = listOfSets[index].weight.toString();
        repsController.text = listOfSets[index].reps.toString();
      }

      updateActiveList(index);
    });
  }

  // Set selected tile as active
  void updateActiveList(int index) {
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
              DateFormat('EEE dd/MM').format(DateTime.now()),
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
                  itemCount: listOfSets.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      // Display tiles based on exercise category
                      child: tileSelector(index),
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
