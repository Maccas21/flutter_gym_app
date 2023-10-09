import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:intl/intl.dart';

// ignore_for_file: prefer_adjacent_string_concatenation
// ignore_for_file: prefer_interpolation_to_compose_strings

class TileTypeHelper extends StatefulWidget {
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  final bool activeTile;
  final int index;

  const TileTypeHelper({
    super.key,
    required this.exercise,
    required this.exerciseSet,
    required this.activeTile,
    required this.index,
  });

  @override
  State<TileTypeHelper> createState() => _TileTypeHelperState();
}

class _TileTypeHelperState extends State<TileTypeHelper> {
  // Return tile widget based on weight/reps OR distance/time OR time
  Widget tileSelector() {
    if (widget.exercise.exerciseType == ExerciseType.cardio) {
      String formatedDistance =
          NumberFormat('0.###').format(widget.exerciseSet.distance);
      String tempText = '${widget.index + 1} -' +
          ' $formatedDistance km' +
          ' ${toStringDuration(widget.exerciseSet.duration)}';
      return Text(tempText);
    } else if (widget.exercise.exerciseType == ExerciseType.static) {
      String tempText = '${widget.index + 1} -' +
          ' ${toStringDuration(widget.exerciseSet.duration)}';
      return Text(tempText);
    } else {
      //ExerciseType.weight
      String formatedWeight =
          NumberFormat('0.###').format(widget.exerciseSet.weight);
      String tempText = '${widget.index + 1} -' +
          ' Weight $formatedWeight kg' +
          ' Reps ${widget.exerciseSet.reps}';
      return Text(tempText);
    }
  }

  @override
  Widget build(BuildContext context) {
    //return tileSelector();
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: widget.activeTile ? Colors.amber : Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: tileSelector(),
    );
  }
}
