import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/init_dependencies.dart';
import '../../domain/entities/analytics_enums.dart';
import '../../domain/entities/analytics_stats.dart';
import '../bloc/analytics_bloc.dart';

class AnalyticsDashboardPage extends StatelessWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => serviceLocator<AnalyticsBloc>()
        ..add(const AnalyticsEvent.loadAnalyticsData(timeFrame: TimeFrame.week)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Listening History'),
        ),
        body: const _AnalyticsBody(),
      ),
    );
  }
}

class _AnalyticsBody extends StatelessWidget {
  const _AnalyticsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          failure: (f) => Center(child: Text('Error: ${f.message}')),
          loaded: (data) => SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TimeFrameSelector(selected: data.selectedTimeFrame),
                const SizedBox(height: 20),
                _GeneralStatsCard(stats: data.stats),
                const SizedBox(height: 24),
                const Text('Top Genres',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _GenreChart(genres: data.topGenres),
                const SizedBox(height: 24),
                const Text('Top Songs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                _TopList(items: data.topSongs),
                const SizedBox(height: 24),
                const Text('Top Artists',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                _TopList(items: data.topArtists),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TimeFrameSelector extends StatelessWidget {
  final TimeFrame selected;

  const _TimeFrameSelector({required this.selected});

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TimeFrame>(
      segments: const [
        ButtonSegment(value: TimeFrame.day, label: Text('Day')),
        ButtonSegment(value: TimeFrame.week, label: Text('Week')),
        ButtonSegment(value: TimeFrame.month, label: Text('Month')),
        ButtonSegment(value: TimeFrame.all, label: Text('All')),
      ],
      selected: {selected},
      onSelectionChanged: (newSelection) {
        context.read<AnalyticsBloc>().add(
              AnalyticsEvent.loadAnalyticsData(timeFrame: newSelection.first),
            );
      },
    );
  }
}

class _GeneralStatsCard extends StatelessWidget {
  final ListeningStats stats;

  const _GeneralStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(
              label: 'Minutes',
              value: stats.totalMinutes.toString(),
              icon: Icons.timer,
            ),
            _StatItem(
              label: 'Songs',
              value: stats.totalSongsPlayed.toString(),
              icon: Icons.music_note,
            ),
            // Simple logic for "Favorite Time"
            _StatItem(
              label: 'Peak Time',
              value: _getPeakTime(stats.timeOfDayDistribution),
              icon: Icons.wb_sunny,
            ),
          ],
        ),
      ),
    );
  }

  String _getPeakTime(Map<String, int> dist) {
    if (dist.isEmpty) return '-';
    var sortedKeys = dist.keys.toList(growable: false)
      ..sort((k1, k2) => dist[k2]!.compareTo(dist[k1]!));
    return sortedKeys.first.toUpperCase();
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem(
      {required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 28, color: Theme.of(context).primaryColor),
        const SizedBox(height: 8),
        Text(value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _TopList extends StatelessWidget {
  final List<TopItem> items;

  const _TopList({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const Text('No data yet.');
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
          ),
          title: Text(item.title),
          subtitle: Text(item.subtitle ?? item.type),
          trailing: Text('${item.count} plays'),
        );
      },
    );
  }
}

class _GenreChart extends StatelessWidget {
  final List<TopItem> genres;

  const _GenreChart({required this.genres});

  @override
  Widget build(BuildContext context) {
    if (genres.isEmpty) {
      return const SizedBox(height: 200, child: Center(child: Text('No Data')));
    }

    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < genres.length) {
                    // Show first 3 chars of genre
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        genres[value.toInt()].title.substring(0, 3.clamp(0, genres[value.toInt()].title.length)),
                        style: const TextStyle(fontSize: 10),
                      ),
                    );
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: const FlGridData(show: false),
          barGroups: genres.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.count.toDouble(),
                  color: Theme.of(context).primaryColor,
                  width: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
