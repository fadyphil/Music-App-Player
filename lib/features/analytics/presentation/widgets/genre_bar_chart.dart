import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';
import '../../domain/entities/analytics_stats.dart';

class GenreBarChart extends StatelessWidget {
  final List<TopItem> genres;

  const GenreBarChart({super.key, required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return const SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'No genres data yet',
            style: TextStyle(color: AppPallete.grey),
          ),
        ),
      );
    }

    // Colors for the bars
    final colors = [
      AppPallete.neonPurple,
      AppPallete.hotPink,
      AppPallete.electricBlue,
      AppPallete.warmOrange,
      AppPallete.primaryGreen,
    ];

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (genres.map((e) => e.count).fold(0, (p, c) => c > p ? c : p) * 1.2).toDouble(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index >= 0 && index < genres.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                        genres[index].title.length > 3 
                            ? genres[index].title.substring(0, 3) 
                            : genres[index].title,
                        style: const TextStyle(
                          color: AppPallete.grey,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: 5,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppPallete.white.withValues(alpha: 0.05),
              strokeWidth: 1,
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: genres.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final color = colors[index % colors.length];

            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: item.count.toDouble(),
                  color: color,
                  width: 12,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: (genres.map((e) => e.count).fold(0, (p, c) => c > p ? c : p) * 1.2).toDouble(),
                    color: AppPallete.surfaceLight,
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
