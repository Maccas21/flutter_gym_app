import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExerciseDatabase {
  List<dynamic> exerciseLog = [];
  List<dynamic> currentDayExercises = [];
  String exerciseName;
  DateTime currentDate;

  // reference to Hive box
  final Box box = Hive.box('hivebox');

  ExerciseDatabase({required this.exerciseName, required this.currentDate});

  void initDatabase() {
    // initialize database;
    exerciseLog = box.get(exerciseName) ?? [];
    currentDayExercises =
        box.get(DateFormat('YYMMDD').format(currentDate)) ?? [];
  }

  void updateDatabase() {
    box.put(exerciseName, exerciseLog);
    box.put(DateFormat('YYMMDD').format(currentDate), currentDayExercises);
  }

  void updateDayLog(ExerciseDayLog log) {
    int index = getDayLogIndex(log.date);

    // add updated log if not empty
    if (log.sets.isNotEmpty) {
      // add if not already in else update
      index == -1 ? exerciseLog.add(log) : exerciseLog[index] = log;

      // check if exercises have been added to database for current date
      if (!currentDayExercises.contains(exerciseName)) {
        currentDayExercises.add(exerciseName);
      }
    } else {
      // remove from database if empty
      index != -1 ? exerciseLog.removeAt(index) : ();
      currentDayExercises.removeWhere((exercise) => exercise == exerciseName);
    }

    //update database
    updateDatabase();
  }

  // get specific day from list
  ExerciseDayLog getDayLog(DateTime queryDate) {
    ExerciseDayLog returnValue = exerciseLog.firstWhere((dayLog) {
      return DateUtils.isSameDay(dayLog.date, queryDate);
    }, orElse: () => ExerciseDayLog(date: currentDate));
    return returnValue;
  }

  // get index of specific day from list
  int getDayLogIndex(DateTime queryDate) {
    return exerciseLog.indexWhere((dayLog) {
      return DateUtils.isSameDay(dayLog.date, queryDate);
    });
  }
}

class DayDatabase {
  DateTime currentDate = DateTime.now();
  List<dynamic> currentDateExercises = [];
  List<ExerciseDayLog> dayExerciseList = [];

  // reference to Hive box
  final Box box = Hive.box('hivebox');

  void initDB() {
    updateDatabase();
  }

  void updateDatabase() {
    currentDateExercises =
        box.get(DateFormat('YYMMDD').format(currentDate)) ?? [];

    dayExerciseList.clear();

    for (var exercise in currentDateExercises) {
      // get list from database
      List<dynamic> temp = box.get(exercise) ?? [];
      // get specific day
      ExerciseDayLog returnValue = temp.firstWhere((dayLog) {
        return DateUtils.isSameDay(dayLog.date, currentDate);
      }, orElse: () => ExerciseDayLog(date: DateTime.now()));

      // add to current list if found
      if (returnValue != ExerciseDayLog(date: DateTime.now())) {
        dayExerciseList.add(returnValue);
      }
    }
  }

  void setDay(DateTime newDate) {
    currentDate = newDate;
    updateDatabase();
  }
}
