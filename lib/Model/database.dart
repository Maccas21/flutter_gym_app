import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Database {
  List<dynamic> exerciseLog = [];
  String exerciseName;

  Database({required this.exerciseName});

  void initDatabase() {
    // initialize database;
    exerciseLog = box.get(exerciseName) ?? [];
  }

  // reference to Hive box
  final Box box = Hive.box('hivebox');

  void updateDatabase() {
    box.put(exerciseName, exerciseLog);
  }

  void updateDayLog(ExerciseDayLog log) {
    int index = getDayLogIndex(log.date);

    // if exerciseLog contains log with same date then remove old log
    if (index != -1) {
      exerciseLog.removeAt(index);
    }

    // add updated log
    exerciseLog.add(log);

    //update database
    updateDatabase();
  }

  // get specific day from list
  ExerciseDayLog getDayLog(DateTime queryDate) {
    ExerciseDayLog returnValue = exerciseLog.firstWhere((dayLog) {
      return DateUtils.isSameDay(dayLog.date, queryDate);
    }, orElse: () => ExerciseDayLog());
    return returnValue;
  }

  // get index of specific day from list
  int getDayLogIndex(DateTime queryDate) {
    return exerciseLog.indexWhere((dayLog) {
      return DateUtils.isSameDay(dayLog.date, queryDate);
    });
  }
}
