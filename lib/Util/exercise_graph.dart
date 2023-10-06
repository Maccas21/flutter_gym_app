import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_gym_app/Model/database_to_graph.dart';
import 'package:flutter_gym_app/Model/exercises.dart';
import 'package:hive/hive.dart';

class ExerciseGraph extends StatefulWidget {
  final String exerciseName;
  final ExerciseType exerciseType;
  final String graphType;
  final DateTime startDate;
  final DateTime endDate;
  final bool customDates;

  const ExerciseGraph({
    super.key,
    required this.exerciseName,
    required this.exerciseType,
    required this.graphType,
    required this.startDate,
    required this.endDate,
    required this.customDates,
  });

  @override
  State<ExerciseGraph> createState() => _ExerciseGraphState();
}

class _ExerciseGraphState extends State<ExerciseGraph> {
  final List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  TextStyle textStyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  late DatabaseToGraph dbToGraph;
  late StreamSubscription<BoxEvent> hiveListener;

  @override
  void initState() {
    super.initState();

    reinit();

    // listen for changes in the database and update page
    hiveListener = Hive.box('hivebox').watch().listen((event) {
      reinit();
    });
  }

  void reinit() {
    dbToGraph = DatabaseToGraph(
      exerciseName: widget.exerciseName,
      graphType: widget.graphType,
      exerciseType: widget.exerciseType,
      startDate: widget.startDate,
      endDate: widget.endDate,
      customDates: widget.customDates,
      textStyle: textStyle,
      touchBackgroundColour: Colors.blueGrey.shade400,
    );
  }

  @override
  void dispose() {
    hiveListener.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: LineChart(
        LineChartData(
          minX: dbToGraph.minX,
          maxX: dbToGraph.maxX,
          minY: dbToGraph.minY,
          maxY: dbToGraph.maxY,
          // XY LABELS
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(),
            rightTitles: const AxisTitles(),
            leftTitles: dbToGraph.yAxisTitle,
            bottomTitles: dbToGraph.xAxisTitle,
          ),
          // BORDER LINES
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(
                color: Colors.white,
              ),
              bottom: BorderSide(
                color: Colors.white,
              ),
            ),
          ),
          // DATA POINTS
          lineBarsData: [
            LineChartBarData(
                spots: dbToGraph.dataPoints,
                isCurved: false,
                gradient: LinearGradient(
                  colors: gradientColors,
                ),
                barWidth: 5,
                // DOT POINTS
                dotData: FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: 2,
                      color: Colors.white,
                      strokeWidth: 0,
                    );
                  },
                ),
                belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: gradientColors
                          .map((color) => color.withOpacity(0.3))
                          .toList(),
                    ))),
          ],
          // TOUCH POINTS AND LABELS
          lineTouchData: LineTouchData(
            // TOUCH LABEL
            touchTooltipData: dbToGraph.touchLabels,
            // TOUCH POINTS CONFIG
            getTouchedSpotIndicator: (barData, spotIndexes) {
              return spotIndexes.map((spotIndex) {
                return TouchedSpotIndicatorData(
                  // LINE UNDER POINT
                  FlLine(
                    color: gradientColors[1],
                    strokeWidth: 1,
                  ),
                  // ON TOUCH DOT POINT CONFIG
                  FlDotData(
                    getDotPainter: (spot, percent, barData, index) {
                      return FlDotCirclePainter(
                        radius: 2,
                        color: Colors.white,
                        strokeWidth: 0,
                      );
                    },
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
