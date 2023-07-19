import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
part 'exercises.g.dart';

enum ExerciseType { cardio, static, weights }

class Exercise {
  String name;
  String force;
  String category;
  bool defaultExercise;
  List<String> primaryMuscles;
  List<String> secondaryMuscles;
  List<String> instructions;
  late ExerciseType exerciseType;

  Exercise({
    required this.name,
    required this.force,
    required this.category,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.defaultExercise,
  }) {
    if (category == 'cardio') {
      exerciseType = ExerciseType.cardio;
    } else if (force == 'static') {
      exerciseType = ExerciseType.static;
    } else {
      exerciseType = ExerciseType.weights;
    }
  }
}

List<Exercise> defaultExercises = [];
const List<String> muscleGroups = [
  'abdominals',
  'abductors',
  'adductors',
  'biceps',
  'calves',
  'chest',
  'forearms',
  'glutes',
  'hamstrings',
  'lats',
  'lower back',
  'middle back',
  'neck',
  'quadriceps',
  'shoulders',
  'traps',
  'triceps'
];

const muscleCategory = {
  'All': [],
  'Arms': [
    'biceps',
    'forearms',
    'triceps',
  ],
  'Back': [
    'lats',
    'lower back',
    'middle back',
    'neck',
    'shoulders',
    'traps',
  ],
  'Cardio': [],
  'Chest': [
    'chest',
  ],
  'Core': [
    'abdominals',
    'abductors',
    'adductors',
  ],
  'Legs': [
    'calves',
    'glutes',
    'hamstrings',
    'quadriceps',
  ],
};

// Fetch content from json file
Future<void> readJSON() async {
  // check if list is not empty
  if (defaultExercises.isEmpty) {
    // load json file
    final String response =
        await rootBundle.loadString('assets/exercises.json');
    final data = await json.decode(response);

    // fill list with json data
    for (var exercise in data['exercises']) {
      defaultExercises.add(Exercise(
        name: exercise['name'],
        force: exercise['force'] ?? '',
        category: exercise['category'],
        primaryMuscles: List<String>.from(exercise['primaryMuscles']),
        secondaryMuscles: List<String>.from(exercise['secondaryMuscles'] ?? []),
        instructions: List<String>.from(exercise['instructions'] ?? []),
        defaultExercise: true,
      ));
    }
  }
}

// When changing RUN COMMAND: "flutter packages pub run build_runner build"
// regenerates type adapters used by hive

@HiveType(typeId: 1)
class ExerciseSet {
  @HiveField(0)
  int weight = 0;
  @HiveField(1)
  int reps = 0;
  @HiveField(2)
  int distance = 0;
  @HiveField(3)
  int durationHours = 0;
  @HiveField(4)
  int durationMins = 0;
  @HiveField(5)
  int durationSecs = 0;
}

@HiveType(typeId: 2)
class ExerciseDayLog {
  @HiveField(0)
  List<ExerciseSet> sets = [];
  @HiveField(1)
  DateTime date;

  ExerciseDayLog({required this.date});
}
