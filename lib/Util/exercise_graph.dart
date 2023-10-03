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
    fontSize: 15,
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
    );
  }

  @override
  void dispose() {
    hiveListener.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: dbToGraph.minX,
        maxX: dbToGraph.maxX,
        minY: dbToGraph.minY,
        maxY: dbToGraph.maxY,
        // XY LABELS
        titlesData: FlTitlesData(
          show: true,
          //topTitles: const AxisTitles(),
          //rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                switch (value.toInt()) {
                  case 1:
                    return Text(
                      '10k',
                      style: textStyle,
                    );
                  case 3:
                    return Text(
                      '30k',
                      style: textStyle,
                    );
                  case 5:
                    return Text(
                      '50k',
                      style: textStyle,
                    );
                }
                return const Text('');
              },
              reservedSize: 38,
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 1:
                      return Text(
                        'FEB',
                        style: textStyle,
                      );
                    case 4:
                      return Text(
                        'MAY',
                        style: textStyle,
                      );
                    case 7:
                      return Text(
                        'AUG',
                        style: textStyle,
                      );
                    case 10:
                      return Text(
                        'NOV',
                        style: textStyle,
                      );
                  }
                  return const Text('');
                },
                reservedSize: 25),
          ),
        ),
        // GRID LINES
        gridData: FlGridData(
          drawHorizontalLine: false,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return const FlLine(
              color: Colors.white,
              strokeWidth: 1,
            );
          },
          getDrawingVerticalLine: (value) {
            return const FlLine(
              color: Colors.white,
              strokeWidth: 1,
            );
          },
        ),
        // BORDER LINES
        borderData: FlBorderData(
          show: true,
          border: const Border(
            left: BorderSide(
              color: Colors.white,
              width: 1,
            ),
            bottom: BorderSide(
              color: Colors.white,
              width: 1,
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
          getTouchedSpotIndicator: (barData, spotIndexes) {
            return spotIndexes.map((spotIndex) {
              return TouchedSpotIndicatorData(
                // LINE UNDER POINT
                FlLine(
                  color: gradientColors[1],
                  strokeWidth: 1,
                ),
                // DOT POINT
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
          // TOUCH LABEL
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.shade400,
            getTooltipItems: (List<LineBarSpot> touchedSpots) {
              return touchedSpots.map((flSpot) {
                return LineTooltipItem(
                  '${flSpot.x.toString()} \n',
                  textStyle,
                  children: [
                    TextSpan(
                      text: flSpot.y.toString(),
                      style: textStyle,
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
