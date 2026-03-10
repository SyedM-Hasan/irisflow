class AnalyticsState {
  final String selectedPeriod;
  final List<Map<String, dynamic>> weeklyData;
  final List<Map<String, dynamic>> focusDistribution;

  const AnalyticsState({
    required this.selectedPeriod,
    required this.weeklyData,
    required this.focusDistribution,
  });

  AnalyticsState copyWith({
    String? selectedPeriod,
    List<Map<String, dynamic>>? weeklyData,
    List<Map<String, dynamic>>? focusDistribution,
  }) {
    return AnalyticsState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      weeklyData: weeklyData ?? this.weeklyData,
      focusDistribution: focusDistribution ?? this.focusDistribution,
    );
  }
}
