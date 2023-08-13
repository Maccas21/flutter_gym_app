import 'package:flutter/material.dart';

class ExerciseHistoryTab extends StatefulWidget {
  const ExerciseHistoryTab({super.key});

  @override
  State<ExerciseHistoryTab> createState() => _ExerciseHistoryTabState();
}

class _ExerciseHistoryTabState extends State<ExerciseHistoryTab> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('This is the Exercise History Tab'),
    );
  }
}
