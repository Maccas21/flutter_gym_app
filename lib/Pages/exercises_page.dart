import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Pages/add_exercise_page.dart';
import 'package:flutter_gym_app/Pages/exercise_list_page.dart';
import 'package:flutter_gym_app/Pages/graph_tab.dart';
import 'package:flutter_gym_app/Pages/history_tab.dart';

class ExercisesPage extends StatefulWidget {
  final DateTime currentDate;
  const ExercisesPage({super.key, required this.currentDate});

  @override
  State<ExercisesPage> createState() => _ExercisesPageState();
}

class _ExercisesPageState extends State<ExercisesPage> {
  int currentPage = 0;
  late List<Widget> exercisePages = [
    ExerciseListPage(
      listViewOnTap: listViewOnTap,
      currentDate: widget.currentDate,
    ),
    const GraphTab(),
    const HistoryTab(),
  ];

  void listViewOnTap(String name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return AddExercisePage(
            exerciseName: name,
            currentDate: widget.currentDate,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercises"),
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.adaptive.arrow_back)),
      ),
      body: exercisePages[currentPage],
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.fitness_center), label: "Exercises"),
          NavigationDestination(
              icon: Icon(Icons.stacked_line_chart), label: "Graph"),
          NavigationDestination(icon: Icon(Icons.history), label: "History"),
        ],
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
          });
        },
        selectedIndex: currentPage,
      ),
    );
  }
}
