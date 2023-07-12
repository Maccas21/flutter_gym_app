import 'package:hive/hive.dart';
part 'exercises.g.dart';

class Exercise {
  String name;
  String force;
  String category;
  bool defaultExercise;
  List<String> primaryMuscles;
  List<String> secondaryMuscles;
  List<String> instructions;

  Exercise({
    required this.name,
    required this.force,
    required this.category,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.instructions,
    required this.defaultExercise,
  });
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
