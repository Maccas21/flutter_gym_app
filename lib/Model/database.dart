import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class ExerciseDatabase {
  late List<dynamic> exerciseLog; //List<ExerciseDayLog>
  late List<dynamic> currentDayExercises; //List<String>
  late List<dynamic> datesHistory; //List<DateTime>
  late ExerciseDayLog currentDayLog;
  late Exercise exercise;
  String exerciseName;
  DateTime currentDate;

  // reference to Hive box
  final Box box = Hive.box('hivebox');

  ExerciseDatabase({required this.exerciseName, required this.currentDate}) {
    // initialize database;
    exerciseLog = box.get(exerciseName) ?? [];
    currentDayExercises = box.get(DateFormat('yMMd').format(currentDate)) ?? [];
    datesHistory = box.get('datesHistory') ?? [];

    currentDayLog = getDayLog(currentDate);

    exercise = defaultExercises.where((exerciseValue) {
      final exerciseName = exerciseValue.name.toLowerCase();
      final input = exerciseName.toLowerCase();

      return exerciseName.contains(input);
    }).first;
  }

  void updateIntoDatabase() {
    // sorted by newer dates first
    exerciseLog.sort((a, b) {
      return b.date.compareTo(a.date);
    });
    box.put(exerciseName, exerciseLog);
    box.put(DateFormat('yMMd').format(currentDate), currentDayExercises);

    // sorted by newer dates first
    datesHistory.sort((a, b) {
      return b.compareTo(a);
    });
    box.put('datesHistory', datesHistory);
  }

  void updateFromDatabase() {
    exerciseLog = box.get(exerciseName) ?? [];
    currentDayExercises = box.get(DateFormat('yMMd').format(currentDate)) ?? [];
    datesHistory = box.get('datesHistory') ?? [];
  }

  void addDayLog() {
    int index = getDayLogIndex(currentDayLog.date);

    // add if not already in else update
    index == -1
        ? exerciseLog.add(currentDayLog)
        : exerciseLog[index] = currentDayLog;

    // check if exercises have been added to database for current date
    if (!currentDayExercises.contains(exerciseName)) {
      currentDayExercises.add(exerciseName);
    }

    // check if there are exercises in current date
    if (currentDayExercises.isNotEmpty) {
      int index = datesHistory.indexWhere(
          (comparingDate) => DateUtils.isSameDay(comparingDate, currentDate));
      // not yet added to history
      if (index == -1) {
        datesHistory.add(currentDate);
      }
    }

    // update max indexes
    setMaxIndexes();

    //update database
    updateIntoDatabase();
  }

  void deleteDayLog() {
    int index = getDayLogIndex(currentDayLog.date);

    if (currentDayLog.sets.isEmpty && index != -1) {
      // remove from database if empty
      exerciseLog.removeAt(index);
      currentDayExercises.removeWhere((exercise) => exercise == exerciseName);
    }

    // if no exercises in current date
    if (currentDayExercises.isEmpty) {
      int index = datesHistory.indexWhere(
          (comparingDate) => DateUtils.isSameDay(comparingDate, currentDate));
      // history contains current date
      if (index != -1) {
        datesHistory.removeAt(index);
      }
    }

    //update database
    updateIntoDatabase();
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

  // set the indexes of the ExerciseSet with the highest value of
  // weight, reps, duration and distance for the current day
  void setMaxIndexes() {
    // set to -1 if list is empty
    if (currentDayLog.sets.isNotEmpty) {
      // filter by exercise type
      if (exercise.exerciseType == ExerciseType.cardio) {
        setMaxDistanceIndex();
        setMaxDurationIndex();
      } else if (exercise.exerciseType == ExerciseType.static) {
        setMaxDurationIndex();
      } else {
        //ExerciseType.weights
        setMaxWeightIndex();
        setMaxRepsIndex();
      }
    } else {
      currentDayLog.maxWeightIndex = -1;
      currentDayLog.maxRepsIndex = -1;
      currentDayLog.maxDistanceIndex = -1;
      currentDayLog.maxDurationIndex = -1;
    }
  }

  // set the index for the highest weight from each set in current day
  void setMaxWeightIndex() {
    int maxWeight = currentDayLog.sets[0].weight;

    for (int i = 1; i < currentDayLog.sets.length; i++) {
      int compare = currentDayLog.sets[i].weight;
      if (maxWeight < compare) {
        maxWeight = compare;
        currentDayLog.maxWeightIndex = i;
      }
    }
  }

  // set the index for the highest rep from each set in current day
  void setMaxRepsIndex() {
    int maxReps = currentDayLog.sets[0].reps;

    for (int i = 1; i < currentDayLog.sets.length; i++) {
      int compare = currentDayLog.sets[i].reps;
      if (maxReps < compare) {
        maxReps = compare;
        currentDayLog.maxWeightIndex = i;
      }
    }
  }

  // set the index for the furthest distance from each set in current day
  void setMaxDistanceIndex() {
    int maxDistance = currentDayLog.sets[0].distance;

    for (int i = 1; i < currentDayLog.sets.length; i++) {
      int compare = currentDayLog.sets[i].distance;
      if (maxDistance < compare) {
        maxDistance = compare;
        currentDayLog.maxWeightIndex = i;
      }
    }
  }

  // set the index for the longest duration from each set in current day
  void setMaxDurationIndex() {
    Duration maxDuration = currentDayLog.sets[0].duration;

    for (int i = 1; i < currentDayLog.sets.length; i++) {
      Duration compare = currentDayLog.sets[i].duration;
      if (maxDuration < compare) {
        maxDuration = compare;
        currentDayLog.maxWeightIndex = i;
      }
    }
  }
}

class DayDatabase {
  DateTime currentDate;
  List<dynamic> currentDateExercises = []; //List<String>
  List<ExerciseDayLog> dayExerciseList = [];

  // reference to Hive box
  final Box box = Hive.box('hivebox');

  DayDatabase(this.currentDate) {
    updateDatabase();
  }

  void updateDatabase() {
    currentDateExercises =
        box.get(DateFormat('yMMd').format(currentDate)) ?? [];

    dayExerciseList.clear();

    for (String exercise in currentDateExercises) {
      // get list from database
      List<dynamic> temp = box.get(exercise) ?? [];

      // get specific day
      ExerciseDayLog returnValue = temp.firstWhere((dayLog) {
        return DateUtils.isSameDay(dayLog.date, currentDate);
      }, orElse: () => ExerciseDayLog(date: DateTime.now()));

      // add to current list if found
      if (returnValue.sets.isNotEmpty) {
        dayExerciseList.add(returnValue);
      }
    }
  }

  void setDay(DateTime newDate) {
    currentDate = newDate;
    updateDatabase();
  }
}
