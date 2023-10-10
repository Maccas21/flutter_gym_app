import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:intl/intl.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
}

class ExerciseListPage extends StatefulWidget {
  final Function listViewOnTap;
  final DateTime currentDate;
  final bool dateVisible;

  const ExerciseListPage({
    super.key,
    required this.listViewOnTap,
    required this.currentDate,
    this.dateVisible = true,
  });

  @override
  State<ExerciseListPage> createState() => _ExerciseListPageState();
}

class _ExerciseListPageState extends State<ExerciseListPage> {
  TextEditingController searchBarController = TextEditingController();
  List<Exercise> exerciseList = defaultExercises;
  Map<String, bool> activeFilter = {
    'All': true,
    'Arms': false,
    'Back': false,
    'Cardio': false,
    'Chest': false,
    'Core': false,
    'Legs': false,
  };

  @override
  void dispose() {
    searchBarController.dispose();

    super.dispose();
  }

  // Search list of exercises based on search bar
  void searchExercises(String query) {
    List<Exercise> filteredMuscle = [];

    // check if muscle category is selected
    for (var group in activeFilter.keys) {
      if (activeFilter[group] == true) {
        // get all exercises based on muscle group
        filteredMuscle = getExercisesFromMuscleGroup(group, defaultExercises);
        break;
      }
    }

    setState(() {
      // set current list to filtered exercises
      exerciseList = getExercisesFromName(query, filteredMuscle);
    });
  }

  // Filter exercises based on muscle group
  void filterExercises(String query) {
    setActiveFilter(query);

    setState(() {
      // set list based on search bar
      exerciseList =
          getExercisesFromName(searchBarController.text, defaultExercises);

      if (query != 'All') {
        exerciseList = getExercisesFromMuscleGroup(query, exerciseList);
      }
    });
  }

  // Return list of matching exercises based on name from source list
  List<Exercise> getExercisesFromName(String query, List<Exercise> source) {
    return source.where((exercise) {
      final exerciseName = exercise.name.toLowerCase();
      final input = query.toLowerCase();

      return exerciseName.contains(input);
    }).toList();
  }

  // Return list of exercises with matching muscle group from source list
  List<Exercise> getExercisesFromMuscleGroup(
      String query, List<Exercise> source) {
    return query == 'All'
        ? defaultExercises
        : source.where((exercise) {
            // check for cardio group
            if (query == 'Cardio' &&
                exercise.category.toLowerCase() == 'cardio') {
              return true;
            }
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
  }

  // Clear search bar, reset list and muscle category
  void clearSearchBar() {
    // clear textfield
    searchBarController.clear();

    // show all exercises
    exerciseList = defaultExercises;

    // reset active filters
    setActiveFilter('All');

    // close keyboard
    //FocusManager.instance.primaryFocus?.unfocus();
  }

  // Set which filter is active
  void setActiveFilter(String query) {
    activeFilter.forEach((key, value) {
      activeFilter[key] = false;
    });

    setState(() {
      activeFilter[query] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: const Icon(Icons.add),
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: TextField(
              controller: searchBarController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchBarController.text == ''
                    ? null
                    : IconButton(
                        splashRadius: 20,
                        icon: const Icon(Icons.clear),
                        onPressed: clearSearchBar,
                      ),
                hintText: 'Search Exercises',
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
              ),
              onChanged: searchExercises,
            ),
          ),
          Visibility(
            visible: widget.dateVisible,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  DateFormat('EEEE, MMMM dd').format(widget.currentDate),
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 35,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: muscleCategory.length,
              itemBuilder: (context, index) {
                return TextButton(
                  onPressed: activeFilter.values.elementAt(index) == true
                      ? null
                      : () {
                          filterExercises(muscleCategory.keys.elementAt(index));
                        },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    minimumSize: Size.zero,
                  ),
                  child: Text(muscleCategory.keys.elementAt(index)),
                );
              },
            ),
          ),
          Expanded(
            child: Scrollbar(
              interactive: true,
              child: ListView.builder(
                itemCount: exerciseList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      exerciseList[index].name,
                      style: const TextStyle(fontSize: 15),
                    ),
                    subtitle: Text(
                      exerciseList[index].primaryMuscles.first.toTitleCase(),
                      style: const TextStyle(fontSize: 14),
                    ),
                    visualDensity: const VisualDensity(vertical: -4),
                    onTap: () {
                      widget.listViewOnTap(exerciseList[index].name);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
