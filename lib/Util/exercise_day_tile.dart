import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:flutter_gym_app/Util/tile_type_helper.dart';

class ExerciseDayTile extends StatefulWidget {
  final ExerciseDayLog dayLog;
  final String exerciseName;
  const ExerciseDayTile(
      {super.key, required this.dayLog, required this.exerciseName});

  @override
  State<ExerciseDayTile> createState() => _ExerciseDayTileState();
}

class _ExerciseDayTileState extends State<ExerciseDayTile> {
  late Exercise exercise;

  @override
  void initState() {
    super.initState();

    exercise = defaultExercises.where((exerciseValue) {
      final exerciseName = exerciseValue.name.toLowerCase();
      final input = widget.exerciseName.toLowerCase();

      return exerciseName.contains(input);
    }).first;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      decoration: BoxDecoration(
        color: Colors.blueGrey.shade400,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Text(
              widget.exerciseName,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: widget.dayLog.sets.length,
            itemBuilder: (context, index) {
              return TileTypeHelper(
                exercise: exercise,
                exerciseSet: widget.dayLog.sets[index],
                activeTile: false,
                index: index,
              );
            },
          ),
        ],
      ),
    );
  }
}

class DayTile extends StatefulWidget {
  final DayDatabase db;
  final Function dayTileOnTap;

  const DayTile({super.key, required this.db, required this.dayTileOnTap});

  @override
  State<DayTile> createState() => _DayTileState();
}

class _DayTileState extends State<DayTile> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.db.currentDateExercises.length,
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            widget.dayTileOnTap(
              widget.db.currentDateExercises[index],
              widget.db.currentDate,
            );
          },
          child: ExerciseDayTile(
            dayLog: widget.db.dayExerciseList[index],
            exerciseName: widget.db.currentDateExercises[index],
          ),
        );
      }),
    );
  }
}
