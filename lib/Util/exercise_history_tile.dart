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
  late ExerciseType exerciseType;
  late StreamSubscription hiveListener;

  int maxWeight = 0;
  int maxReps = 0;
  Duration maxDuration = const Duration(seconds: 0);
  int maxDistance = 0;
  DateTime dateOfMax = DateTime.now();

  @override
  void initState() {
    super.initState();

    exerciseType = defaultExercises.firstWhere((element) {
      return element.name == widget.db.exerciseName;
    }).exerciseType;

    reinit();

    hiveListener = Hive.box('hivebox').watch().listen((event) {
      reinit();
    });
  }

  void reinit() {
    switch (exerciseType) {
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
    super.dispose();

    hiveListener.cancel();
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
        Duration comparing = Duration(
          hours: set.durationHours,
          minutes: set.durationMins,
          seconds: set.durationSecs,
        );
        if (maxDuration < comparing) {
          maxDuration = comparing;
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
          maxDuration = Duration(
            hours: set.durationHours,
            minutes: set.durationMins,
            seconds: set.durationSecs,
          );
          dateOfMax = log.date;
        }
      }
    }
  }

  // Get tile based on ExerciseType
  Widget tileType() {
    switch (exerciseType) {
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

  String toStringDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitsMin = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitsSec = twoDigits(duration.inSeconds.remainder(60));
    return '${duration.inHours}:$twoDigitsMin:$twoDigitsSec';
  }

  @override
  Widget build(BuildContext context) {
    return !widget.left && exerciseType == ExerciseType.static
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
