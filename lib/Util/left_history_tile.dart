import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';

class LeftHistoryTile extends StatefulWidget {
  final ExerciseDatabase db;
  const LeftHistoryTile({super.key, required this.db});

  @override
  State<LeftHistoryTile> createState() => _LeftHistoryTileState();
}

class _LeftHistoryTileState extends State<LeftHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.blueGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('This is the Left'),
      ),
    );
  }
}
