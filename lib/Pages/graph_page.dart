import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Pages/exercise_list_page.dart';
import 'package:flutter_gym_app/Pages/exercises_tabview.dart';

class GraphTab extends StatefulWidget {
  const GraphTab({super.key});

  @override
  State<GraphTab> createState() => _GraphTabState();
}

class _GraphTabState extends State<GraphTab> {
  void listViewOnTap(String name) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return ExercisesTabView(
            exerciseName: name,
            currentDate: DateTime.now(),
            hasAdd: false,
          );
        },
      ),
    );
  }

  void onPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Statistics')),
            body: ExerciseListPage(
              listViewOnTap: listViewOnTap,
              currentDate: DateTime.now(),
              dateVisible: false,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistics"),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              color: Colors.blueGrey,
              child: const Center(
                child: Text(
                  'Graph Goes Here',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: onPressed,
              child: const Text('All Exercises'),
            ),
          ],
        ),
      ),
    );
  }
}
