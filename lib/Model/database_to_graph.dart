import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class DatabaseToGraph {
  late List<dynamic> exerciseLog; //List<ExerciseDayLog>
  List<FlSpot> dataPoints = List.empty(growable: true);

  // reference to Hive box
  final Box box = Hive.box('hivebox');

  TextStyle textStyle;
  Color touchBackgroundColour;

  ExerciseType exerciseType;
  String exerciseName;
  String graphType;

  DateTime startDate;
  DateTime endDate;
  bool customDates;

  double minX = 0;
  double maxX = 1;
  double minY = 0;
  double maxY = 1;

  AxisTitles xAxisTitle = const AxisTitles();
  AxisTitles yAxisTitle = const AxisTitles();
  LineTouchTooltipData touchLabels = const LineTouchTooltipData();

  DatabaseToGraph({
    required this.exerciseName,
    required this.graphType,
    required this.exerciseType,
    required this.startDate,
    required this.endDate,
    required this.customDates,
    this.textStyle = const TextStyle(),
    this.touchBackgroundColour = Colors.white,
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

    // get xy labels
    xAxisTitle = getXTitle();
    yAxisTitle = getYTitle();

    // get touch point labels
    touchLabels = getTouchLabels();
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
              double maxDayDistance =
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
              double maxDayWeight = dayLog.sets[dayLog.maxWeightIndex].weight;

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
      if (exerciseLog.isNotEmpty) {
        // shift points to the front if not enough data points
        if (daysBetween(exerciseLog.last.date, endDate) < difference) {
          startDate = exerciseLog.last.date;
          endDate = startDate.add(Duration(days: difference.toInt()));
        }
      }
      return difference;
    }
  }

  // Get maxX based on All dates in db
  // return a minimum of 30 days range
  double getMaxXAll() {
    // set startDate to the earliest date in log
    if (exerciseLog.isNotEmpty) {
      startDate = exerciseLog.last.date;
    }

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

    return max(minPoint - 2, 0);
  }

  double getMaxY() {
    if (dataPoints.isEmpty) {
      return 50;
    }

    double maxPoint = dataPoints.map((point) => point.y).reduce(max);

    return maxPoint > 5 ? maxPoint + 2 : maxPoint;
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

  // Return title widget for Y axis
  AxisTitles getXTitle() {
    // get interval
    double interval = ((maxX - minX) / 5).round().toDouble();

    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        interval: 1,
        getTitlesWidget: (value, meta) {
          // shift values to the right
          if (value % interval == (interval / 3).round()) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(
                // convert date to string based on startdate
                offsetToDateStringLabel(value.toInt()),
                style: textStyle,
              ),
            );
          }
          return const Text('');
        },
        //reservedSize: 25,
      ),
    );
  }

  // Return formated date string based on offset from startdate
  String offsetToDateStringLabel(int offset) {
    return DateFormat('MMM dd')
        .format(startDate.add(Duration(days: (offset))))
        .toUpperCase();
  }

  // Return title widget for Y axis
  AxisTitles getYTitle() {
    // get interval. To 3 decimal places if maxY < 1 otherwise to 1 decimal
    double interval = roundDouble(((maxY - minY) / 6), maxY < 1 ? 3 : 1);

    return AxisTitles(
      sideTitles: SideTitles(
        interval: maxY < 1 ? 0.01 : 0.1,
        showTitles: true,
        getTitlesWidget: (value, meta) {
          if (doubleToIntMod((value - minY), interval) == 0) {
            return SideTitleWidget(
              axisSide: meta.axisSide,
              child: Text(
                NumberFormat(maxY > 15 ? '0' : '0.0#').format(value),
                style: textStyle,
              ),
            );
          }
          return const Text('');
        },
        reservedSize: 40,
      ),
    );
  }

  // Return value rounded to N places
  double roundDouble(double value, int places) {
    double mod = pow(10, places).toDouble();
    return ((value * mod).round().toDouble() / mod);
  }

  // Return modulus operation on doubles to account for floating point errors
  int doubleToIntMod(double a, double b) {
    int aToInt = (roundDouble(a, 2) * pow(10, 2)).round();
    int bToInt = (roundDouble(b, 2) * pow(10, 2)).round();

    return aToInt % bToInt;
  }

  // Return touch point labels
  LineTouchTooltipData getTouchLabels() {
    return LineTouchTooltipData(
      tooltipBgColor: touchBackgroundColour,
      getTooltipItems: (List<LineBarSpot> touchedSpots) {
        return touchedSpots.map((flSpot) {
          String xTouchLabel = offsetToDateStringLabel(flSpot.x.toInt());

          // remove trailing zero after decimal for numbers below 10
          String formatString = flSpot.y < 10 ? '0.0##' : '0.###';
          String yTouchLabel = NumberFormat(formatString).format(flSpot.y);

          return LineTooltipItem(
            '$xTouchLabel \n$yTouchLabel',
            textStyle,
          );
        }).toList();
      },
    );
  }
}
