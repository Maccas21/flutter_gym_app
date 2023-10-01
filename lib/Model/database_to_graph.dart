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

  int minX = 0;
  int maxX = 1;
  int minY = 0;
  int maxY = 1;

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

    // get y bounds
    minY = getMinY();
    maxY = getMaxY();

    // get data points
    dataPoints = getSpots();

    // get x labels
    // get y labels
    // get touch point labels
  }

  List<FlSpot> getSpots() {
    List<FlSpot> spots = List<FlSpot>.empty(growable: true);

    if (exerciseType == ExerciseType.cardio) {
      // CHECK WHICH CARDIO
      // 'Max Distance'
      // 'Max Duration'
    } else if (exerciseType == ExerciseType.static) {
      // CHECK WHICH STATIC
      // 'Max Duration'
    } else {
      // CHECK WHICH WEIGHTS
      switch (graphType) {
        case 'Heaviest Weight':
        case 'Total Volume':
        case 'Max Reps':
        case 'Total Reps':
        default:
      }
    }

    return spots;
  }

  int getMinX() {
    return 0;
  }

  // Get maxX based on start and end dates
  int getMaxX() {
    int difference = startDate.difference(endDate).inDays.abs();

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
  int getMaxXAll() {
    // set startDate to the earliest date in log
    startDate = exerciseLog.last.date;

    // check the difference between today and earliest date
    int difference = DateTime.now().difference(startDate).inDays.abs();

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
  int getMaxXCustom() {
    startDate = DateTime.now().subtract(const Duration(days: 30));
    endDate = DateTime.now();
    return 30;
  }

  int getMinY() {
    return 0;
  }

  int getMaxY() {
    return 0;
  }
}
