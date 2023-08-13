import 'package:flutter/material.dart';

class ExerciseGraphTab extends StatefulWidget {
  const ExerciseGraphTab({super.key});

  @override
  State<ExerciseGraphTab> createState() => _ExerciseGraphTabState();
}

class _ExerciseGraphTabState extends State<ExerciseGraphTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Graph Tab'),
    );
  }
}
