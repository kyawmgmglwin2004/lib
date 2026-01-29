import 'dart:math';

enum DisplayType { hourly, daily, monthly }

class PowerHistoryData {
  final String label;
  final double generatedEnergy;
  final double selfConsumption;
  final double powerUsage;
  final DateTime date;

  PowerHistoryData({
    required this.label,
    required this.generatedEnergy,
    required this.selfConsumption,
    required this.powerUsage,
    required this.date,
  });
}

// 1. Day pick → 24 hours data
List<PowerHistoryData> getMockHourlyData(int year, int month, int day) {
  final random = Random();
  final dateBase = DateTime(year, month, day);

  return List.generate(24, (hour) {
    final baseValue = 40000.0 + random.nextInt(20000);
    return PowerHistoryData(
      label: "$hour:00",
      generatedEnergy: baseValue * 0.6,
      selfConsumption: baseValue * 0.3,
      powerUsage: baseValue.toDouble(),
      date: DateTime(year, month, day, hour),
    );
  });
}

List<PowerHistoryData> getMockDailyData(int year, int month) {
  final random = Random();
  final daysInMonth = DateTime(year, month + 2, 0).day;

  return List.generate(daysInMonth, (index) {
    final day = index + 1;
    final baseValue = 100000.0 + random.nextInt(5000);
    return PowerHistoryData(
      label: "$day",
      generatedEnergy: baseValue * 0.6,
      selfConsumption: baseValue * 0.4,
      powerUsage: baseValue.toDouble(),
      date: DateTime(year, month, day),
    );
  });
}

List<PowerHistoryData> getMockMonthlyData(
  int year,
  int startMonth,
  int endMonth,
) {
  final random = Random();

  return List.generate(endMonth - startMonth + 1, (index) {
    final month = startMonth + index;
    final baseValue = 20000.0 + random.nextInt(10000);
    return PowerHistoryData(
      label: "$month",
      generatedEnergy: baseValue * 0.6,
      selfConsumption: baseValue * 0.45,
      powerUsage: baseValue.toDouble(),
      date: DateTime(year, month, 1),
    );
  });
}
