import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_pallete.dart';

class ListeningTimeChart extends StatelessWidget {
  final int totalMinutes;
  final int totalSongs;

  const ListeningTimeChart({
    super.key,
    required this.totalMinutes,
    required this.totalSongs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 0,
                  centerSpaceRadius: 70,
                  startDegreeOffset: -90,
                  sections: [
                    PieChartSectionData(
                      color: AppPallete.primaryGreen,
                      value: 100, // Full circle for now, or could be relative to daily goal
                      title: '',
                      radius: 20,
                      showTitle: false,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$totalMinutes',
                    style: const TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      color: AppPallete.white,
                    ),
                  ),
                  const Text(
                    'min',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppPallete.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              context,
              color: AppPallete.primaryGreen,
              label: 'Total Songs: $totalSongs',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context,
      {required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                blurRadius: 6,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppPallete.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
