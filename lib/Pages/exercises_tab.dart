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
  TextEditingController searchBarController = TextEditingController();
  List<Exercise> exerciseList = defaultExercises;

  @override
  void initState() {
    super.initState();
  }

  // Fetch content from json file
  Future<void> readJSON() async {
    // check if list is not empty
    if (defaultExercises.isEmpty) {
      // load json file
      final String response =
          await rootBundle.loadString('assets/exercises.json');
      final data = await json.decode(response);

      // fill list with json data
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
  }

  // Search list of exercises based in search bar
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

  // Filter exercises based on set categories
  void filterExercises(String query) {
    if (query == 'All' || query == 'Cardio') {
      setState(() {
        exerciseList = defaultExercises;
      });
    } else {
      final searching = defaultExercises.where((exercise) {
        // check filter group
        for (var muscle in muscleCategory[query]!) {
          var exerciseMuscle = exercise.primaryMuscles.first.toLowerCase();
          var input = muscle.toLowerCase();

          // check if primary muscle
          if (exerciseMuscle.contains(input)) return true;

          // check all secondary muscles
          // for (var secondMuscle in exercise.secondaryMuscles) {
          //   exerciseMuscle = secondMuscle.toLowerCase();
          //   if (exerciseMuscle.contains(input)) return true;
          // }
        }

        return false;
      }).toList();

      setState(() {
        exerciseList = searching;
      });
    }
  }

  void clearSearchBar() {
    // clear textfield
    searchBarController.clear();

    // show all exercises
    filterExercises('All');

    // close keyboard
    //FocusManager.instance.primaryFocus?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: searchBarController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    splashRadius: 20,
                    icon: const Icon(Icons.clear),
                    onPressed: clearSearchBar,
                  ),
                  hintText: 'Exercises',
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide:
                        BorderSide(color: Theme.of(context).primaryColor),
                  ),
                ),
                onChanged: searchExercises,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                height: 35,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: muscleCategory.length,
                  itemBuilder: (context, index) {
                    return TextButton(
                      onPressed: () {
                        filterExercises(muscleCategory.keys.elementAt(index));
                      },
                      child: Text(muscleCategory.keys.elementAt(index)),
                    );
                  },
                ),
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
                                title: Text(
                                  exerciseList[index].name,
                                ),
                                subtitle: Text(
                                  exerciseList[index]
                                      .primaryMuscles
                                      .first
                                      .toTitleCase(),
                                ),
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
