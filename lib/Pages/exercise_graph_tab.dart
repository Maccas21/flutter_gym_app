import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Util/exercise_graph.dart';

class ExerciseGraphTab extends StatefulWidget {
  const ExerciseGraphTab({super.key});

  @override
  State<ExerciseGraphTab> createState() => _ExerciseGraphTabState();
}

class _ExerciseGraphTabState extends State<ExerciseGraphTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text('This is the Graph 1'),
          Container(
            height: 250,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ExerciseGraph(),
          ),
          const Text('This is the Graph 2'),
          Container(
            height: 250,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ExerciseGraph(),
          ),
          const Text('This is the Graph 3'),
          Container(
            height: 250,
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const ExerciseGraph(),
          ),
        ],
      ),
    );
  }
}
