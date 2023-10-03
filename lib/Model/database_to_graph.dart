import 'dart:math';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DatabaseToGraph {
  late List<dynamic> exerciseLog; //List<ExerciseDayLog>

  String exerciseName;
  String graphType;
  ExerciseType exerciseType;
  DateTime startDate;
  DateTime endDate;
  bool customDates;

  double minX = 0;
  double maxX = 1;
  double minY = 0;
  double maxY = 1;

  List<FlSpot> dataPoints = List.empty(growable: true);

  // reference to Hive box
  final Box box = Hive.box('hivebox');

  DatabaseToGraph({
    required this.exerciseName,
    required this.graphType,
    required this.exerciseType,
    required this.startDate,
    required this.endDate,
    required this.customDates,
  }) {
    // initialize database;
    exerciseLog = box.get(exerciseName) ?? [];

    // get x bounds
    minX = getMinX();
    maxX = getMaxX();

    // get data points
    dataPoints = getSpots();

    // get y bounds
    minY = getMinY();
    maxY = getMaxY();

    // get x labels
    // get y labels
    // get touch point labels
  }

  List<FlSpot> getSpots() {
    List<FlSpot> spots = List<FlSpot>.empty(growable: true);

    // list if reversed so earliest date is first
    exerciseLog = exerciseLog.reversed.toList();

    for (ExerciseDayLog dayLog in exerciseLog) {
      // check if there are sets and within date range
      if (isInbetweenDates(startDate, endDate, dayLog.date) &&
          (dayLog.sets.isNotEmpty && dayLog.maxDistanceIndex >= 0 ||
              dayLog.maxDurationIndex >= 0 ||
              (dayLog.maxWeightIndex >= 0 && dayLog.maxRepsIndex >= 0))) {
        if (exerciseType == ExerciseType.cardio ||
            exerciseType == ExerciseType.static) {
          switch (graphType) {
            case 'Max Distance':
              int maxDayDistance =
                  dayLog.sets[dayLog.maxDistanceIndex].distance;
              spots.add(FlSpot(
                daysBetween(startDate, dayLog.date),
                maxDayDistance.toDouble(),
              ));
              break;
            case 'Max Duration':
              double maxDayDuration =
                  dayLog.sets[dayLog.maxDurationIndex].duration.inSeconds / 60;
              spots.add(FlSpot(
                daysBetween(startDate, dayLog.date),
                maxDayDuration,
              ));
              break;
            case 'Best Pace':
              // get best pace for the day. best pace = time/distance
              double bestPace = dayLog.sets.map((set) {
                return set.distance != 0
                    ? ((set.duration.inSeconds / 60) / set.distance)
                    : 0.0;
              }).reduce(max);
              spots.add(FlSpot(
                daysBetween(startDate, dayLog.date),
                bestPace,
              ));
              break;
            default:
              break;
          }
        } else {
          switch (graphType) {
            case 'Heaviest Weight':
              int maxDayWeight = dayLog.sets[dayLog.maxWeightIndex].weight;

              spots.add(FlSpot(
                daysBetween(startDate, dayLog.date),
                maxDayWeight.toDouble(),
              ));
              break;
            case 'Total Volume':
              // sum of all weights in every set for day
              double totalWeight = dayLog.sets
                  .map((set) => set.weight)
                  .reduce((a, b) => a + b)
                  .toDouble();

              spots.add(FlSpot(
                daysBetween(startDate, dayLog.date),
                totalWeight,
              ));
              break;
            case 'Max Reps':
              int maxDayRep = dayLog.sets[dayLog.maxRepsIndex].reps;

              spots.add(FlSpot(
                daysBetween(startDate, dayLog.date),
                maxDayRep.toDouble(),
              ));
              break;
            case 'Total Reps':
              // sum of reps in every set for day
              double totalReps = dayLog.sets
                  .map((set) => set.reps)
                  .reduce((a, b) => a + b)
                  .toDouble();

              spots.add(FlSpot(
                daysBetween(startDate, dayLog.date),
                totalReps,
              ));
              break;
            default:
              break;
          }
        }
      }
    }

    return spots;
  }

  double getMinX() {
    return 0;
  }

  // Get maxX based on start and end dates
  double getMaxX() {
    double difference = daysBetween(startDate, endDate);

    // if true get custom date values
    if (customDates == true) {
      return getMaxXCustom();
    }

    // if difference is 0 then get all dates
    if (difference == 0) {
      return getMaxXAll();
    } else {
      // differences should be 90, 180, 365
      return difference;
    }
  }

  // Get maxX based on All dates in db
  // return a minimum of 30 days range
  double getMaxXAll() {
    // set startDate to the earliest date in log
    startDate = exerciseLog.last.date;

    // check the difference between today and earliest date
    double difference = daysBetween(DateTime.now(), startDate);

    if (difference < 30) {
      // endDate is 30 days from earliest date in log
      endDate = startDate.add(const Duration(days: 30));
      return 30;
    } else {
      endDate = DateTime.now();
      return difference;
    }
  }

  // Get maxX based on custom dates
  // CUSTOM DATES NOT IMPLEMENTED YET
  double getMaxXCustom() {
    startDate = DateTime.now().subtract(const Duration(days: 30));
    endDate = DateTime.now();
    return 30;
  }

  double getMinY() {
    if (dataPoints.isEmpty) {
      return 0;
    }

    double minPoint = dataPoints.map((point) => point.y).reduce(min);

    return max(minPoint - 5, 0);
  }

  double getMaxY() {
    if (dataPoints.isEmpty) {
      return 50;
    }

    double maxPoint = dataPoints.map((point) => point.y).reduce(max);

    return maxPoint + 5;
  }

  // Get the absolute days between two dates
  double daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round().abs().toDouble();
  }

  // Check if compare is inbetween the two dates
  bool isInbetweenDates(DateTime start, DateTime end, DateTime compare) {
    // modify to be inclusive
    start = start.subtract(const Duration(days: 1));
    end = end.add(const Duration(days: 1));

    // normalise dates to midnight to get accurate values
    DateTime newStart = DateTime(start.year, start.month, start.day);
    DateTime newEnd = DateTime(end.year, end.month, end.day);
    DateTime newCompare = DateTime(compare.year, compare.month, compare.day);

    return newStart.isBefore(newCompare) && newEnd.isAfter(newCompare);
  }
}
