import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class TimeOfDayChart extends StatelessWidget {
  final Map<String, int> distribution;

  const TimeOfDayChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    if (distribution.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(
          child: Text('No time data yet', style: TextStyle(color: AppPallete.grey)),
        ),
      );
    }

    final morning = distribution['morning'] ?? 0;
    final afternoon = distribution['afternoon'] ?? 0;
    final night = distribution['night'] ?? 0;

    final spots = [
      FlSpot(0, morning.toDouble()),
      FlSpot(1, afternoon.toDouble()),
      FlSpot(2, night.toDouble()),
    ];

    return SizedBox(
      height: 150,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0: return const _BottomTitle('Morning');
                    case 1: return const _BottomTitle('Afternoon');
                    case 2: return const _BottomTitle('Night');
                    default: return const SizedBox.shrink();
                  }
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 2,
          minY: 0,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppPallete.electricBlue,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: AppPallete.white,
                    strokeWidth: 2,
                    strokeColor: AppPallete.electricBlue,
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    AppPallete.electricBlue.withValues(alpha: 0.3),
                    AppPallete.electricBlue.withValues(alpha: 0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomTitle extends StatelessWidget {
  final String text;
  const _BottomTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          color: AppPallete.grey,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
