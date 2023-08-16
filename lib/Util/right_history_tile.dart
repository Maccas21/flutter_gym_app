import 'package:flutter/material.dart';
import 'package:flutter_gym_app/Model/database.dart';

class RightHistoryTile extends StatefulWidget {
  final ExerciseDatabase db;
  const RightHistoryTile({super.key, required this.db});

  @override
  State<RightHistoryTile> createState() => _RightHistoryTileState();
}

class _RightHistoryTileState extends State<RightHistoryTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      height: 100,
      decoration: BoxDecoration(
        color: Colors.lightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text('This is the Right'),
      ),
    );
  }
}
