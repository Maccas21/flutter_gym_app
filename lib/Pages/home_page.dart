import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Pages/exercises_page.dart';
import 'package:flutter_gym_app/Pages/routines_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test"),
      ),
      body: Center(
        child: Column(children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const RoutinesPage();
                  },
                ),
              );
            },
            child: const Text("Routines"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return const ExercisesPage();
                  },
                ),
              );
            },
            child: const Text("Exercises"),
          ),
        ]),
      ),
    );
  }
}
