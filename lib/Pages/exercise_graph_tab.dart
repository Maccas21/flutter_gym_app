import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:flutter_gym_app/Util/exercise_graph.dart';

class ExerciseGraphTab extends StatefulWidget {
  final String exerciseName;

  const ExerciseGraphTab({
    super.key,
    required this.exerciseName,
  });

  @override
  State<ExerciseGraphTab> createState() => _ExerciseGraphTabState();
}

class _ExerciseGraphTabState extends State<ExerciseGraphTab> {
  late Exercise exercise;
  DateTime startDate = DateTime.now().subtract(const Duration(days: 90));
  DateTime endDate = DateTime.now();
  bool customDates = false;

  List<Widget> graphs = List.empty(growable: true);

  @override
  void initState() {
    super.initState();

    exercise = defaultExercises.where((exerciseValue) {
      final exerciseName = exerciseValue.name.toLowerCase();
      final input = widget.exerciseName.toLowerCase();

      return exerciseName.contains(input);
    }).first;

    exerciseTypeSelector();
  }

  // Return graph based on type
  Widget graphSelector(ExerciseType exerciseType, String graphType) {
    return Column(
      // unique key for build updates
      key: ValueKey(graphType + startDate.toString()),
      children: [
        Text(graphType),
        Container(
          height: 250,
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ExerciseGraph(
            exerciseName: widget.exerciseName,
            exerciseType: exerciseType,
            graphType: graphType,
            startDate: startDate,
            endDate: endDate,
            customDates: customDates,
          ),
        ),
      ],
    );
  }

  // Get list of graphs by exercise type
  void exerciseTypeSelector() {
    graphs.clear();

    if (exercise.exerciseType == ExerciseType.cardio) {
      // max distance - furthest distance for that day
      graphs.add(graphSelector(exercise.exerciseType, 'Max Distance'));
      // max duration - longest duration for that day
      graphs.add(graphSelector(exercise.exerciseType, 'Max Duration'));
      // best pace - highest min/distance value (--- EXTRA FEATURE ---)
    } else if (exercise.exerciseType == ExerciseType.static) {
      // max duration - longest duration for that day
      graphs.add(graphSelector(exercise.exerciseType, 'Max Duration'));
    } else {
      // ExerciseType.weights
      // heaviest weight - highest weight for that day
      graphs.add(graphSelector(exercise.exerciseType, 'Heaviest Weight'));

      // total volume - sum of weight for that day
      graphs.add(graphSelector(exercise.exerciseType, 'Total Volume'));

      // max reps - highest rep for that day
      graphs.add(graphSelector(exercise.exerciseType, 'Max Reps'));

      // total reps - sum of reps for that day
      graphs.add(graphSelector(exercise.exerciseType, 'Total Reps'));
    }
  }

  // Change the start date of X axis
  void changeDateRange(int range) {
    setState(() {
      startDate = DateTime.now().subtract(Duration(days: range));
      endDate = DateTime.now();

      // update graphs
      exerciseTypeSelector();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  changeDateRange(90);
                },
                child: const Text('3M'),
              ),
              ElevatedButton(
                onPressed: () {
                  changeDateRange(180);
                },
                child: const Text('6M'),
              ),
              ElevatedButton(
                onPressed: () {
                  changeDateRange(365);
                },
                child: const Text('1Y'),
              ),
              ElevatedButton(
                onPressed: () {
                  changeDateRange(0);
                },
                child: const Text('ALL'),
              ),
            ],
          ),
          ...graphs,
        ],
      ),
    );
  }
}
