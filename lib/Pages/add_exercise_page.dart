import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Util/distance_time_input.dart';
import 'package:flutter_gym_app/Util/time_input.dart';
import 'package:flutter_gym_app/Util/weight_rep_input.dart';
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
      return WeightRepInput(
        weightController: weightController,
        repsController: repsController,
      );
    }
  }

  // Add set to list
  void addSet() {}

  // Delete set from list
  void deleteSet() {}

  // Update set
  void updateSet(int index) {}

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
            // display based on exercise category
            inputSelector(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Add'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Delete'),
                ),
              ],
            ),
            // ListView of sets
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${index + 1} THIS IS AN EXAMPLE SET'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
