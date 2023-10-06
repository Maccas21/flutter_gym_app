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
  List<bool> activeButton = List.filled(5, true);

  @override
  void initState() {
    super.initState();

    exercise = defaultExercises.where((exerciseValue) {
      final exerciseValueName = exerciseValue.name.toLowerCase();
      final input = widget.exerciseName.toLowerCase();

      return exerciseValueName.contains(input);
    }).first;

    exerciseTypeSelector();

    // disable first sort button
    activeButton[0] = false;
  }

  // Return graph based on type
  Widget graphSelector(ExerciseType exerciseType, String graphType) {
    return Container(
      // unique key for build updates
      key: ValueKey(graphType + startDate.toString()),
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.fromLTRB(8, 15, 8, 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            graphType,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ExerciseGraph(
            exerciseName: widget.exerciseName,
            exerciseType: exerciseType,
            graphType: graphType,
            startDate: startDate,
            endDate: endDate,
            customDates: customDates,
          ),
        ],
      ),
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
      // best pace - highest min/distance value
      graphs.add(graphSelector(exercise.exerciseType, 'Best Pace'));
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

  // Get list of buttons to change display range
  List<OutlinedButton> getButtons() {
    List<OutlinedButton> returnList = List.empty(growable: true);
    const List<int> ranges = [90, 180, 365, 0];
    const List<String> buttonText = ['3M', '6M', '1Y', 'ALL'];

    for (int i = 0; i < 4; i++) {
      returnList.add(
        OutlinedButton(
          onPressed: activeButton[i]
              ? () {
                  changeDateRange(ranges[i]);
                  activeButton = List.filled(5, true);
                  activeButton[i] = false;
                }
              : null,
          child: Text(buttonText[i]),
        ),
      );
    }

    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...getButtons(),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                ...graphs,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
