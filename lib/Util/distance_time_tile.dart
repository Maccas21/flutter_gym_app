import 'package:flutter/material.dart';

class DistanceTimeTile extends StatelessWidget {
  final int index;
  final int distance;
  final int hours;
  final int mins;
  final int secs;
  final bool active;

  const DistanceTimeTile({
    super.key,
    required this.index,
    required this.distance,
    required this.hours,
    required this.mins,
    required this.secs,
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
          Text(' $distance km'),
          Text(' ${hours.toString().padLeft(2, '0')}:'),
          Text('${mins.toString().padLeft(2, '0')}:'),
          Text(secs.toString().padLeft(2, '0')),
        ],
      ),
    );
  }
}
