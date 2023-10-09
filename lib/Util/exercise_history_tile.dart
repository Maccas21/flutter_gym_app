import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExerciseHistoryTile extends StatefulWidget {
  final ExerciseDatabase db;
  final bool left;
  const ExerciseHistoryTile({super.key, required this.db, this.left = true});

  @override
  State<ExerciseHistoryTile> createState() => _ExerciseHistoryTileState();
}

class _ExerciseHistoryTileState extends State<ExerciseHistoryTile> {
  late StreamSubscription hiveListener;

  double maxWeight = 0;
  int maxReps = 0;
  Duration maxDuration = const Duration(seconds: 0);
  double maxDistance = 0;
  DateTime dateOfMax = DateTime.now();

  @override
  void initState() {
    super.initState();

    reinit();

    hiveListener = Hive.box('hivebox').watch().listen((event) {
      reinit();
    });
  }

  void reinit() {
    switch (widget.db.exercise.exerciseType) {
      case ExerciseType.cardio:
        widget.left ? getMaxDistance() : getMaxDuration();
        break;
      case ExerciseType.static:
        getMaxDuration();
        break;
      default:
        widget.left ? getMaxWeight() : getMaxReps();
        break;
    }
  }

  @override
  void dispose() {
    hiveListener.cancel();

    super.dispose();
  }

  // Get highest weight from db for exercise. Also get date and rep
  void getMaxWeight() {
    for (ExerciseDayLog log in widget.db.exerciseLog) {
      for (ExerciseSet set in log.sets) {
        if (maxWeight < set.weight) {
          maxWeight = set.weight;
          maxReps = set.reps;
          dateOfMax = log.date;
        }
      }
    }
  }

  // Get highest rep from db for exercise. Also get date and weight
  void getMaxReps() {
    for (ExerciseDayLog log in widget.db.exerciseLog) {
      for (ExerciseSet set in log.sets) {
        if (maxReps < set.reps) {
          maxReps = set.reps;
          maxWeight = set.weight;
          dateOfMax = log.date;
        }
      }
    }
  }

  // Get longest duration from db for exercise. Also get date and distance
  void getMaxDuration() {
    for (ExerciseDayLog log in widget.db.exerciseLog) {
      for (ExerciseSet set in log.sets) {
        if (maxDuration < set.duration) {
          maxDuration = set.duration;
          maxDistance = set.distance;
          dateOfMax = log.date;
        }
      }
    }
  }

  // Get furthest distance from db for exercise. Also get date and duration
  void getMaxDistance() {
    for (ExerciseDayLog log in widget.db.exerciseLog) {
      for (ExerciseSet set in log.sets) {
        if (maxDistance < set.distance) {
          maxDistance = set.distance;
          maxDuration = set.duration;
          dateOfMax = log.date;
        }
      }
    }
  }

  // Get tile based on ExerciseType
  Widget tileType() {
    switch (widget.db.exercise.exerciseType) {
      case ExerciseType.cardio:
        if (widget.left) {
          // max distance
          return tileTextSelector('Max Distance', '$maxDistance km',
              ' (${toStringDuration(maxDuration)})');
        } else {
          // max duration
          return tileTextSelector('Max Duration', toStringDuration(maxDuration),
              ' ($maxDistance km)');
        }
      case ExerciseType.static:
        if (widget.left) {
          // max duration
          return tileTextSelector(
              'Max Duration', toStringDuration(maxDuration), '');
        }
      default:
        // ExerciseType.weights
        if (widget.left) {
          // max weights
          return tileTextSelector(
              'Max Weights', '$maxWeight kg', ' ($maxReps reps)');
        } else {
          // max reps
          return tileTextSelector(
              'Max Reps', '$maxReps reps', ' ($maxWeight kg)');
        }
    }

    // no matching case return empty widget
    return const SizedBox();
  }

  Widget tileTextSelector(String title, String dataMain, String dataSub) {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 12, 0, 0),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 10),
          child: Text(
            DateFormat('MMMM dd').format(dateOfMax),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
        ),
        Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
            child: Row(
              children: [
                Text(
                  dataMain,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  dataSub,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                  ),
                )
              ],
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return !widget.left &&
            widget.db.exercise.exerciseType == ExerciseType.static
        ? const SizedBox()
        : Container(
            margin: const EdgeInsets.all(8),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: tileType(),
          );
  }
}
