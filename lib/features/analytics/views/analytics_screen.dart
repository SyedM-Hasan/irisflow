import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/app_theme_colors.dart';
import '../../../shared/widgets/app_bottom_nav_bar.dart';
import '../../../shared/widgets/app_card.dart';
import '../viewmodels/analytics_viewmodel.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.themeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Analytics', style: AppTextStyles.displayMedium),
                  const _PeriodSelector(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 20),
                    _WeeklyPerformanceCard(),
                    SizedBox(height: 16),
                    _SummaryRow(),
                    SizedBox(height: 24),
                    _FocusDistributionSection(),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}

// ---------------------------------------------------------------------------
// Period Selector
// ---------------------------------------------------------------------------

class _PeriodSelector extends ConsumerWidget {
  const _PeriodSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(analyticsProvider);
    final notifier = ref.read(analyticsProvider.notifier);

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: AnalyticsNotifier.periods.map((p) {
          final selected = state.selectedPeriod == p;
          return GestureDetector(
            onTap: () => notifier.selectPeriod(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: selected ? c.accent : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                p,
                style: AppTextStyles.labelLarge.copyWith(
                  color: selected ? Colors.black : AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekly Bar Chart
// ---------------------------------------------------------------------------

class _WeeklyPerformanceCard extends ConsumerWidget {
  const _WeeklyPerformanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = context.themeColors;
    final state = ref.watch(analyticsProvider);

    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Weekly Performance', style: AppTextStyles.headlineSmall),
          const SizedBox(height: 4),
          Text('Hours worked per day', style: AppTextStyles.bodySmall),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 10,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx < 0 || idx >= state.weeklyData.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            state.weeklyData[idx]['day'] as String,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: c.divider, strokeWidth: 1),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(state.weeklyData.length, (i) {
                  final h = (state.weeklyData[i]['hours'] as double);
                  final isPeak = i == 4;
                  final lighter =
                      Color.lerp(c.accent, Colors.white, 0.3) ?? c.accent;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: h,
                        width: 22,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(6),
                        ),
                        gradient: isPeak
                            ? LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [c.accent, lighter],
                              )
                            : LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [c.cardLight, c.card],
                              ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Summary Row
// ---------------------------------------------------------------------------

class _SummaryRow extends ConsumerWidget {
  const _SummaryRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(analyticsProvider.notifier);
    return Row(
      children: [
        _SummaryCard(
          label: 'Total Hours',
          value: notifier.totalHoursThisWeek.toStringAsFixed(1),
          sub: 'This week',
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          label: 'Daily Avg',
          value: notifier.dailyAverage.toStringAsFixed(1),
          sub: 'Hours/day',
        ),
        const SizedBox(width: 12),
        const _SummaryCard(label: 'Peak Day', value: 'Fri', sub: '8.0 hours'),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label, value, sub;
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: c.card,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: AppTextStyles.headlineMedium.copyWith(color: c.accent),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppTextStyles.bodySmall),
            Text(sub, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Focus Distribution
// ---------------------------------------------------------------------------

class _FocusDistributionSection extends ConsumerWidget {
  const _FocusDistributionSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Focus Distribution'),
        ...state.focusDistribution.map(
          (d) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _FocusDistributionItem(data: d),
          ),
        ),
      ],
    );
  }
}

class _FocusDistributionItem extends StatelessWidget {
  final Map<String, dynamic> data;
  const _FocusDistributionItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final c = context.themeColors;
    final color = data['color'] as Color? ?? c.accent;
    final pct = (data['percent'] as double) * 100;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 4,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data['label'] as String,
                      style: AppTextStyles.titleMedium,
                    ),
                    Text(
                      '${pct.toInt()}%',
                      style: AppTextStyles.accent.copyWith(color: color),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: data['percent'] as double,
                    minHeight: 6,
                    backgroundColor: c.cardLight,
                    valueColor: AlwaysStoppedAnimation(color),
                  ),
                ),
                const SizedBox(height: 4),
                Text(data['time'] as String, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
