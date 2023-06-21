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

class ExerciseSet {
  int weight = 0;
  int reps = 0;
  int distance = 0;
  int durationHours = 0;
  int durationMins = 0;
  int durationSecs = 0;
}
