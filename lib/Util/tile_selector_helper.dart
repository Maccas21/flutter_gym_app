import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:flutter_gym_app/Util/distance_time_tile.dart';
import 'package:flutter_gym_app/Util/time_tile.dart';
import 'package:flutter_gym_app/Util/weight_rep_tile.dart';

class TileSelectorHelper extends StatefulWidget {
  final Exercise exercise;
  final ExerciseSet exerciseSet;
  final bool activeTile;
  final int index;

  const TileSelectorHelper({
    super.key,
    required this.exercise,
    required this.exerciseSet,
    required this.activeTile,
    required this.index,
  });

  @override
  State<TileSelectorHelper> createState() => _TileSelectorHelperState();
}

class _TileSelectorHelperState extends State<TileSelectorHelper> {
  Map<String, bool> exerciseType = {
    'Cardio': false,
    'Static': false,
    'Weights': false
  };

  @override
  void initState() {
    super.initState();

    if (widget.exercise.category == 'cardio') {
      exerciseType['Cardio'] = true;
    } else if (widget.exercise.force == 'static') {
      exerciseType['Static'] = true;
    } else {
      exerciseType['Weights'] = true;
    }
  }

  // Return tile widget based on weight/reps OR distance/time OR time
  Widget tileSelector() {
    if (exerciseType['Cardio'] == true) {
      return DistanceTimeTile(
        index: widget.index,
        distance: widget.exerciseSet.distance,
        hours: widget.exerciseSet.durationHours,
        mins: widget.exerciseSet.durationMins,
        secs: widget.exerciseSet.durationSecs,
        active: widget.activeTile,
      );
    } else if (exerciseType['Static'] == true) {
      return TimeTile(
        index: widget.index,
        hours: widget.exerciseSet.durationHours,
        mins: widget.exerciseSet.durationMins,
        secs: widget.exerciseSet.durationSecs,
        active: widget.activeTile,
      );
    } else {
      return WeightRepTile(
        index: widget.index,
        weight: widget.exerciseSet.weight,
        reps: widget.exerciseSet.reps,
        active: widget.activeTile,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return tileSelector();
  }
}
