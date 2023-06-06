import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'dart:convert';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class ExerciseTab extends StatefulWidget {
  const ExerciseTab({super.key});

  @override
  State<ExerciseTab> createState() => _ExerciseTabState();
}

class _ExerciseTabState extends State<ExerciseTab> {
  TextEditingController controller = TextEditingController();
  List<Exercise> exerciseList = defaultExercises;

  @override
  void initState() {
    super.initState();
  }

  //fetch content from json file
  Future<void> readJSON() async {
    if (defaultExercises.isEmpty) {
      final String response =
          await rootBundle.loadString('assets/exercises.json');
      final data = await json.decode(response);

      for (var exercise in data['exercises']) {
        defaultExercises.add(Exercise(
          name: exercise['name'],
          force: exercise['force'] ?? '',
          primaryMuscles: List<String>.from(exercise['primaryMuscles']),
          secondaryMuscles:
              List<String>.from(exercise['secondaryMuscles'] ?? []),
          instructions: List<String>.from(exercise['instructions'] ?? []),
          defaultExercise: true,
        ));
      }
    }
    //print(defaultExercises.length);
  }

  void searchExercises(String query) {
    final searching = defaultExercises.where((exercise) {
      final exerciseName = exercise.name.toLowerCase();
      final input = query.toLowerCase();

      return exerciseName.contains(input);
    }).toList();

    setState(() {
      exerciseList = searching;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Exercises',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                onChanged: searchExercises,
              ),
              Expanded(
                child: FutureBuilder(
                  future: readJSON(),
                  builder: (context, snapshot) {
                    // if it is done loading
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Scrollbar(
                        child: ListView.builder(
                            itemCount: exerciseList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(exerciseList[index].name),
                                subtitle: Text(exerciseList[index]
                                    .primaryMuscles
                                    .first
                                    .toTitleCase()),
                              );
                            }),
                      );
                    }
                    // if it is still loading
                    else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
