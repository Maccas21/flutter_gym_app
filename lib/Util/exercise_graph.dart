import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ExerciseGraph extends StatefulWidget {
  const ExerciseGraph({super.key});

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

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 11,
        minY: 0,
        maxY: 6,
        // XY LABELS
        titlesData: FlTitlesData(
          show: true,
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
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
                    case 2:
                      return Text(
                        'MAR',
                        style: textStyle,
                      );
                    case 5:
                      return Text(
                        'JUN',
                        style: textStyle,
                      );
                    case 8:
                      return Text(
                        'SEP',
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
              spots: [
                const FlSpot(0, 3),
                const FlSpot(2.6, 2),
                const FlSpot(4.9, 5),
                const FlSpot(6.8, 2.5),
                const FlSpot(8, 4),
                const FlSpot(9.5, 3),
                const FlSpot(11, 4),
              ],
              isCurved: true,
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
                const FlLine(
                  color: Colors.cyanAccent,
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
