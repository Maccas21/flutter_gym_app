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

String toStringDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitsSec = twoDigits(getSecondDuration(duration));
  String twoDigitsMin = twoDigits(getMinuteDuration(duration));
  return '${duration.inHours}:$twoDigitsMin:$twoDigitsSec';
}

int getSecondDuration(Duration duration) {
  return duration.inSeconds.remainder(60);
}

int getMinuteDuration(Duration duration) {
  return duration.inMinutes.remainder(60);
}

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
  double weight = 0;
  @HiveField(1)
  int reps = 0;
  @HiveField(2)
  double distance = 0;
  @HiveField(3)
  Duration duration = const Duration(seconds: 0);
}

@HiveType(typeId: 2)
class ExerciseDayLog {
  @HiveField(0)
  List<ExerciseSet> sets = [];
  @HiveField(1)
  DateTime date;
  @HiveField(2)
  int maxWeightIndex = -1;
  @HiveField(3)
  int maxRepsIndex = -1;
  @HiveField(4)
  int maxDistanceIndex = -1;
  @HiveField(5)
  int maxDurationIndex = -1;

  ExerciseDayLog({required this.date});
}

// Custom Type Adapter for Duration
class DurationAdapter extends TypeAdapter<Duration> {
  @override
  final int typeId = 3;

  @override
  Duration read(BinaryReader reader) {
    return Duration(seconds: reader.read());
  }

  @override
  void write(BinaryWriter writer, Duration obj) {
    writer.write(obj.inSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExerciseDayLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
