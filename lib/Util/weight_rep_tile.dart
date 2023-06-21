import 'package:flutter/material.dart';

class WeightRepTile extends StatelessWidget {
  final int index;
  final int weight;
  final int reps;
  final bool active;

  const WeightRepTile({
    super.key,
    required this.index,
    required this.weight,
    required this.reps,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 5,
      ),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: active ? Colors.amber : Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text('${index + 1} -'),
          Text(' Weight $weight'),
          Text(' Reps $reps'),
        ],
      ),
    );
  }
}
