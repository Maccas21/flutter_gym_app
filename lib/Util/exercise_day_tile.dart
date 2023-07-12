import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:flutter_gym_app/Util/tile_selector_helper.dart';

class ExerciseDayTile extends StatefulWidget {
  final ExerciseDayLog dayLog;
  final String exerciseName;
  const ExerciseDayTile(
      {super.key, required this.dayLog, required this.exerciseName});

  @override
  State<ExerciseDayTile> createState() => _ExerciseDayTileState();
}

class _ExerciseDayTileState extends State<ExerciseDayTile> {
  late Exercise exercise;

  @override
  void initState() {
    super.initState();

    exercise = defaultExercises.where((exerciseValue) {
      final exerciseName = exerciseValue.name.toLowerCase();
      final input = widget.exerciseName.toLowerCase();

      return exerciseName.contains(input);
    }).first;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.exerciseName),
        ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: widget.dayLog.sets.length,
          itemBuilder: (context, index) {
            return TileSelectorHelper(
                exercise: exercise,
                exerciseSet: widget.dayLog.sets[index],
                activeTile: false,
                index: index);
          },
        ),
      ],
    );
  }
}
